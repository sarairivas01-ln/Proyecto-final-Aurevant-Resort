<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">Restaurante / Bar</h1>
        <p class="text-body-2 text-medium-emphasis">Mesas y platillos del día.</p>
      </div>
      <v-btn variant="outlined" color="#0F3D2E" prepend-icon="mdi-refresh" @click="cargar">
        Actualizar
      </v-btn>
    </div>
    <v-alert v-if="error" type="error" variant="tonal" class="mb-4">{{ error }}</v-alert>
    <v-row class="mb-2">
      <v-col cols="12" sm="4">
        <v-card class="pa-4 resumen">
          <div class="text-caption text-medium-emphasis">Mesas ocupadas</div>
          <div class="text-h5 font-weight-bold">{{ mesasOcupadas }} / {{ mesas.length }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="pa-4 resumen">
          <div class="text-caption text-medium-emphasis">Mesas disponibles</div>
          <div class="text-h5 font-weight-bold">{{ mesasDisponibles }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="pa-4 resumen">
          <div class="text-caption text-medium-emphasis">Platillos en el menú</div>
          <div class="text-h5 font-weight-bold">{{ platillos.length }}</div>
        </v-card>
      </v-col>
    </v-row>
    <v-tabs v-model="tab" color="#0F3D2E" class="mb-4">
      <v-tab value="mesas">Mesas</v-tab>
      <v-tab value="menu">Menú</v-tab>
    </v-tabs>
    <v-window v-model="tab">
      <!-- MESAS -->
      <v-window-item value="mesas">
        <v-row v-if="mesas.length">
          <v-col v-for="m in mesas" :key="m.id_mesa" cols="12" sm="6" md="4" lg="3">
            <v-card class="pa-4" :class="'mesa-' + estadoMesa(m)">
              <div class="d-flex justify-space-between align-center">
                <span class="text-h6">Mesa {{ m.id_mesa }}</span>
                <v-chip size="small" :color="colorMesa(m)" variant="flat">{{ m.estado }}</v-chip>
              </div>
              <p class="text-body-2 mt-2 mb-1">
                <v-icon size="16" class="mr-1">mdi-account-group</v-icon>
                {{ m.capacidad }} personas
              </p>
              <p class="text-body-2 mb-1 text-medium-emphasis">
                <v-icon size="16" class="mr-1">mdi-map-marker</v-icon>
                {{ m.ambiente }}
              </p>
              <p class="text-body-2 mb-0">
                <v-icon size="16" class="mr-1">mdi-account</v-icon>
                <span v-if="reservaActiva(m)" class="font-weight-medium">
                  {{ reservaActiva(m).cliente?.nombre || 'Reservada' }}
                </span>
                <span v-else class="text-medium-emphasis">Sin reserva</span>
              </p>
              <div class="d-flex justify-space-between align-center mt-2">
                <v-btn
                  size="small"
                  variant="text"
                  color="#0F3D2E"
                  class="px-0"
                  prepend-icon="mdi-calendar-plus"
                  :disabled="estadoMesa(m) === 'ocupada'"
                  @click="abrirReserva(m)"
                >
                  Reservar
                </v-btn>
                <v-btn
                  size="small"
                  variant="text"
                  color="#0F3D2E"
                  class="px-0"
                  prepend-icon="mdi-eye"
                  @click="verDetalleMesa(m)"
                >
                  Ver
                </v-btn>
              </div>
            </v-card>
          </v-col>
        </v-row>
        <v-card v-else-if="!cargando" class="pa-8 text-center">
          <v-icon size="48" style="color:#D4B483">mdi-table-chair</v-icon>
          <p class="mt-2 text-body-2 text-medium-emphasis">No hay mesas registradas.</p>
        </v-card>
        <v-progress-linear v-if="cargando" indeterminate color="#0F3D2E" class="mt-4" />
      </v-window-item>
      <v-window-item value="menu">
        <v-card class="pa-4">
          <v-data-table
            :headers="headersMenu"
            :items="platillos"
            density="comfortable"
            no-data-text="No hay platillos en el menú."
          >
            <template #item.imagen="{ item }">
              <v-avatar size="48" rounded class="my-2">
                <v-img :src="urlImagen(item)" :alt="item.nombre" cover>
                  <template #error>
                    <div class="d-flex align-center justify-center fill-height bg-grey-lighten-3">
                      <v-icon size="20" color="grey">mdi-silverware-fork-knife</v-icon>
                    </div>
                  </template>
                </v-img>
              </v-avatar>
            </template>
            <template #item.precio="{ item }">
              ${{ Number(item.precio || 0).toFixed(2) }}
            </template>
          </v-data-table>
        </v-card>
      </v-window-item>
    </v-window>
    <v-dialog v-model="dialogoDetalle" max-width="520">
      <v-card rounded="xl" class="overflow-hidden">
        <div class="pa-5" style="background:#0F3D2E; color:#F5EFE0">
          <div class="d-flex justify-space-between align-center">
            <div>
              <div class="text-caption" style="opacity:.75">Mesa</div>
              <div class="text-h6 font-weight-bold">{{ detalle?.titulo }}</div>
            </div>
            <v-chip :color="detalle?.color" variant="flat" size="small">
              {{ detalle?.estado }}
            </v-chip>
          </div>
          <div class="text-body-2 mt-2">{{ detalle?.subtitulo }}</div>
        </div>
        <v-card-text class="pa-5">
          <template v-for="(fila, i) in detalle?.filas || []" :key="i">
            <div class="d-flex justify-space-between py-2">
              <span class="text-medium-emphasis">{{ fila.etiqueta }}</span>
              <span class="font-weight-medium">{{ fila.valor }}</span>
            </div>
            <v-divider v-if="i < detalle.filas.length - 1" />
          </template>
        </v-card-text>
        <v-card-actions class="px-5 pb-4">
          <v-spacer />
          <v-btn variant="text" @click="dialogoDetalle = false">Cerrar</v-btn>
          <v-btn v-if="detalle?.mesa" color="#0F3D2E" @click="cambiarEstado(detalle.mesa)">
            Cambiar estado
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogoReserva" max-width="560">
      <v-card class="pa-4">
        <h3 class="text-h6 mb-1">Reservar mesa {{ form.id_mesa }}</h3>
        <p class="text-body-2 text-medium-emphasis mb-4">
          Se registrará como <strong>pendiente</strong> hasta que el administrador la apruebe.
        </p>
        <v-alert v-if="errorForm" type="error" variant="tonal" density="compact" class="mb-3">
          {{ errorForm }}
        </v-alert>
        <v-select
          v-model="form.id_cliente"
          :items="clientes"
          item-title="nombre"
          item-value="id_cliente"
          label="Cliente"
          variant="outlined"
          density="comfortable"
          no-data-text="No hay clientes registrados"
        />
        <v-text-field
          v-model="form.fecha" type="date" label="Fecha"
          variant="outlined" density="comfortable"
        />
        <v-text-field
          v-model="form.hora" type="time" label="Hora"
          variant="outlined" density="comfortable"
        />
        <v-text-field
          v-model.number="form.personas" type="number" label="Personas"
          variant="outlined" density="comfortable"
          :hint="`Capacidad máxima: ${mesaSeleccionada?.capacidad || '—'}`"
          persistent-hint
        />
        <div class="d-flex justify-end mt-4" style="gap: 8px">
          <v-btn variant="text" @click="dialogoReserva = false">Cancelar</v-btn>
          <v-btn color="#0F3D2E" :loading="guardando" @click="guardarReserva">
            Registrar solicitud
          </v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-snackbar v-model="aviso" color="#0F3D2E" timeout="2200" location="bottom right">
      {{ avisoTexto }}
    </v-snackbar>
  </div>
</template>
<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import api from '@/services/api'
import { listarPlatillos } from '@/services/platillosService'
import { listarClientes } from '@/services/clientesService'
import { crearReservaMesa } from '@/services/reservaMesasService'
const API_BASE = 'http://localhost:8000'
const tab = ref('mesas')
const mesas = ref([])
const platillos = ref([])
const clientes = ref([])
const cargando = ref(false)
const guardando = ref(false)
const error = ref(null)
const errorForm = ref(null)
const dialogoDetalle = ref(false)
const detalle = ref(null)
const dialogoReserva = ref(false)
const form = ref({})
const aviso = ref(false)
const avisoTexto = ref('')
let temporizador = null
const headersMenu = [
  { title: '', key: 'imagen', sortable: false, width: 72 },
  { title: 'Nombre', key: 'nombre' },
  { title: 'Categoría', key: 'categoria' },
  { title: 'Precio', key: 'precio' }
]
const mesasOcupadas = computed(
  () => mesas.value.filter((m) => estadoMesa(m) === 'ocupada').length
)
const mesasDisponibles = computed(
  () => mesas.value.filter((m) => estadoMesa(m) === 'disponible').length
)
const mesaSeleccionada = computed(
  () => mesas.value.find((m) => m.id_mesa === form.value.id_mesa) || null
)
const estadoMesa = (m) => String(m.estado || 'disponible').toLowerCase()
const colorMesa = (m) => {
  const e = estadoMesa(m)
  if (e === 'ocupada') return 'warning'
  if (e === 'reservada') return 'info'
  return 'success'
}
const fecha = (f) => {
  if (!f) return '—'
  const [y, m, d] = String(f).slice(0, 10).split('-')
  return `${d}/${m}/${y}`
}
const hora = (h) => (h ? String(h).slice(0, 5) : '—')
function reservaActiva(mesa) {
  return (mesa.reservas || []).find((r) =>
    ['pendiente', 'confirmada'].includes(String(r.estado).toLowerCase())
  )
}
function urlImagen(item) {
  const ruta = item.img
  if (!ruta) return ''
  if (ruta.startsWith('http')) return ruta
  return `${API_BASE}${ruta.startsWith('/') ? '' : '/'}${ruta}`
}
function mostrarAviso(texto) {
  avisoTexto.value = texto
  aviso.value = true
}
function verDetalleMesa(mesa) {
  const reserva = reservaActiva(mesa)
  const cliente = reserva?.cliente
  detalle.value = {
    titulo: `#${mesa.id_mesa}`,
    estado: mesa.estado,
    color: colorMesa(mesa),
    subtitulo: cliente?.nombre || 'Sin reserva',
    mesa,
    filas: [
      { etiqueta: 'Capacidad', valor: `${mesa.capacidad} personas` },
      { etiqueta: 'Ambiente', valor: mesa.ambiente || '—' },
      { etiqueta: 'Cliente', valor: cliente?.nombre || '—' },
      { etiqueta: 'Teléfono', valor: cliente?.telefono || '—' },
      { etiqueta: 'Fecha', valor: fecha(reserva?.fecha) },
      { etiqueta: 'Hora', valor: hora(reserva?.hora) },
      { etiqueta: 'Personas', valor: reserva?.personas ?? '—' },
      { etiqueta: 'Estado de la reserva', valor: reserva?.estado || '—' }
    ]
  }
  dialogoDetalle.value = true
}
function abrirReserva(mesa) {
  errorForm.value = null
  form.value = {
    id_mesa: mesa.id_mesa,
    id_cliente: null,
    fecha: new Date().toISOString().slice(0, 10),
    hora: '',
    personas: 1
  }
  dialogoReserva.value = true
}
async function guardarReserva() {
  errorForm.value = null
  if (!form.value.id_cliente || !form.value.fecha || !form.value.hora) {
    errorForm.value = 'Completa cliente, fecha y hora.'
    return
  }
  if (mesaSeleccionada.value && form.value.personas > mesaSeleccionada.value.capacidad) {
    errorForm.value = `La mesa solo admite ${mesaSeleccionada.value.capacidad} personas.`
    return
  }
  guardando.value = true
  try {
    await crearReservaMesa(form.value)
    dialogoReserva.value = false
    mostrarAviso('Solicitud registrada. Queda pendiente de aprobación.')
    await cargar()
  } catch (e) {
    errorForm.value = e.response?.data?.message || 'No se pudo registrar la solicitud.'
  } finally {
    guardando.value = false
  }
}
async function cambiarEstado(mesa) {
  const orden = ['disponible', 'reservada', 'ocupada']
  const actual = estadoMesa(mesa)
  const siguiente = orden[(orden.indexOf(actual) + 1) % orden.length]
  try {
    await api.put(`/mesas/${mesa.id_mesa}`, { estado: siguiente })
    mostrarAviso(`Mesa ${mesa.id_mesa} ahora está ${siguiente}`)
    await cargar()
    if (detalle.value?.mesa?.id_mesa === mesa.id_mesa) {
      detalle.value.estado = siguiente
      detalle.value.color = colorMesa({ estado: siguiente })
    }
  } catch (e) {
    error.value = 'No se pudo cambiar el estado de la mesa.'
  }
}
async function cargar() {
  cargando.value = true
  error.value = null
  const [m, pl, c] = await Promise.allSettled([
    api.get('/mesas'),
    listarPlatillos(),
    listarClientes()
  ])
  mesas.value = m.status === 'fulfilled' ? m.value.data : []
  platillos.value = pl.status === 'fulfilled' ? pl.value.data : []
  clientes.value = c.status === 'fulfilled' ? c.value.data : []
  const fallos = []
  if (m.status === 'rejected') fallos.push('mesas')
  if (pl.status === 'rejected') fallos.push('platillos')
  if (c.status === 'rejected') fallos.push('clientes')
  if (fallos.length) {
    error.value = `No se pudo cargar: ${fallos.join(', ')}. Revisa la consola (F12).`
    console.warn('Errores de carga:', { mesas: m, platillos: pl, clientes: c })
  }
  cargando.value = false
}
onMounted(() => {
  cargar()
  temporizador = setInterval(() => {
    if (tab.value !== 'menu' && !dialogoReserva.value) cargar()
  }, 15000)
})
onUnmounted(() => {
  if (temporizador) clearInterval(temporizador)
})
</script>
<style scoped>
.mesa-ocupada { border-left: 4px solid #D4B483; }
.mesa-disponible { border-left: 4px solid #0F3D2E; }
.mesa-reservada { border-left: 4px solid #4A90A4; }
.resumen { border-left: 4px solid #D4B483; }
</style>
