<template>
  <v-container fluid class="pa-6">
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h2 class="text-h5 font-weight-bold">Reservas de mesa</h2>
        <p class="text-body-2 text-medium-emphasis mb-0">
          Mesas, reservas pendientes y liberación automática en 5 minutos.
        </p>
      </div>
      <v-btn variant="outlined" prepend-icon="mdi-refresh" @click="cargar">
        Actualizar
      </v-btn>
    </div>
    <v-alert v-if="error" type="error" density="compact" variant="tonal" class="mb-4">
      {{ error }}
    </v-alert>
    <v-row dense class="mb-6">
      <v-col cols="12" sm="4">
        <v-card class="pa-4">
          <p class="text-caption text-medium-emphasis mb-1">Mesas ocupadas</p>
          <p class="text-h5 font-weight-bold mb-0">{{ ocupadas }} / {{ mesas.length }}</p>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="pa-4">
          <p class="text-caption text-medium-emphasis mb-1">Mesas disponibles</p>
          <p class="text-h5 font-weight-bold mb-0">{{ disponibles }}</p>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="pa-4">
          <p class="text-caption text-medium-emphasis mb-1">Reservas pendientes</p>
          <p class="text-h5 font-weight-bold mb-0">{{ pendientes }}</p>
        </v-card>
      </v-col>
    </v-row>
    <v-row dense>
      <v-col v-for="m in mesas" :key="m.id_mesa" cols="12" sm="6" md="4" lg="3">
        <v-card class="pa-4 h-100" :style="{ borderLeft: `4px solid ${colorMesa(m)}` }">
          <div class="d-flex justify-space-between align-center mb-2">
            <span class="text-h6">Mesa {{ m.id_mesa }}</span>
            <v-chip size="small" :color="colorMesa(m)" variant="flat">
              {{ m.estado }}
            </v-chip>
          </div>
          <p class="text-body-2 mb-1">
            <v-icon size="16" class="mr-1">mdi-account-group</v-icon>
            {{ m.capacidad }} personas
          </p>
          <p class="text-body-2 mb-2 text-medium-emphasis">
            <v-icon size="16" class="mr-1">mdi-map-marker</v-icon>
            {{ m.ambiente }}
          </p>
          <p
            v-if="m.liberar_en && m.estado !== 'disponible'"
            class="text-caption mb-2"
            style="color:#B8860B"
          >
            <v-icon size="14" class="mr-1">mdi-timer-outline</v-icon>
            Se libera en {{ minutosRestantes(m) }}
          </p>
          <div class="d-flex ga-2 mb-3">
            <v-btn
              v-if="m.estado !== 'disponible'"
              size="small"
              variant="tonal"
              color="primary"
              prepend-icon="mdi-lock-open-variant"
              @click="cambiarEstado(m, 'disponible')"
            >
              Liberar
            </v-btn>
            <v-btn
              v-else
              size="small"
              variant="tonal"
              prepend-icon="mdi-account-check"
              @click="cambiarEstado(m, 'ocupada')"
            >
              Ocupar
            </v-btn>
          </div>
          <div class="d-flex justify-space-between align-center">
            <v-btn
              size="small"
              variant="text"
              prepend-icon="mdi-calendar-plus"
              :disabled="m.estado === 'ocupada'"
              @click="abrirReserva(m)"
            >
              Reservar
            </v-btn>
            <v-btn size="small" variant="text" prepend-icon="mdi-eye" @click="verDetalle(m)">
              Ver
            </v-btn>
          </div>
        </v-card>
      </v-col>
    </v-row>
    <v-dialog v-model="dialogoReserva" max-width="520">
      <v-card class="pa-6">
        <h3 class="text-h6 mb-1">Reservar mesa {{ mesaSeleccionada?.id_mesa }}</h3>
        <p class="text-body-2 text-medium-emphasis mb-4">
          Se registrará como <strong>pendiente</strong>. Si no se confirma,
          la mesa se libera en <strong>5 minutos</strong>.
        </p>
        <v-alert v-if="errorForm" type="error" density="compact" variant="tonal" class="mb-4">
          {{ errorForm }}
        </v-alert>
        <v-text-field
          v-model="form.nombre"
          label="Cliente"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-account"
          class="mb-3"
        />
        <v-text-field
          v-model="form.telefono"
          label="Teléfono"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-phone"
          hint="Si ya existe, se reutiliza el cliente"
          persistent-hint
          class="mb-3"
        />
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="form.fecha"
              type="date"
              label="Fecha"
              variant="outlined"
              density="comfortable"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="form.hora"
              type="time"
              label="Hora"
              variant="outlined"
              density="comfortable"
            />
          </v-col>
        </v-row>
        <v-text-field
          v-model.number="form.personas"
          type="number"
          label="Personas"
          variant="outlined"
          density="comfortable"
          :hint="`Capacidad máxima: ${mesaSeleccionada?.capacidad || '—'}`"
          persistent-hint
          class="mb-4"
        />
        <div class="d-flex justify-end ga-2">
          <v-btn variant="text" @click="dialogoReserva = false">Cancelar</v-btn>
          <v-btn color="primary" :loading="guardando" @click="guardarReserva">
            Reservar
          </v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogoDetalle" max-width="460">
      <v-card class="pa-6" v-if="detalle">
        <h3 class="text-h6 mb-1">Mesa {{ detalle.titulo }}</h3>
        <v-chip size="small" :color="detalle.color" variant="flat" class="mb-4">
          {{ detalle.estado }}
        </v-chip>
        <v-list density="compact">
          <v-list-item v-for="f in detalle.filas" :key="f.etiqueta">
            <v-list-item-title class="text-body-2">
              <strong>{{ f.etiqueta }}:</strong> {{ f.valor }}
            </v-list-item-title>
          </v-list-item>
        </v-list>
        <div class="d-flex justify-end mt-4">
          <v-btn variant="text" @click="dialogoDetalle = false">Cerrar</v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-snackbar v-model="aviso" :timeout="3000" color="success">
      {{ avisoTexto }}
    </v-snackbar>
  </v-container>
</template>
<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import api from '@/services/api'
const mesas = ref([])
const error = ref(null)
const aviso = ref(false)
const avisoTexto = ref('')
const dialogoReserva = ref(false)
const mesaSeleccionada = ref(null)
const guardando = ref(false)
const errorForm = ref(null)
const dialogoDetalle = ref(false)
const detalle = ref(null)
function hoyLocal() {
  const d = new Date()
  const off = d.getTimezoneOffset() * 60000
  return new Date(d - off).toISOString().slice(0, 10)
}
const form = ref({
  id_mesa: null,
  nombre: '',
  telefono: '',
  fecha: hoyLocal(),
  hora: '',
  personas: 1
})
let intervalo = null
let reloj = null
const ocupadas = computed(() => mesas.value.filter(m => m.estado === 'ocupada').length)
const disponibles = computed(() => mesas.value.filter(m => m.estado === 'disponible').length)
const pendientes = computed(() =>
  mesas.value.reduce(
    (n, m) => n + (m.reservas || []).filter(r => r.estado === 'pendiente').length,
    0
  )
)
function colorMesa(m) {
  if (m.estado === 'ocupada') return '#B8860B'
  if (m.estado === 'reservada') return '#1E4D3B'
  return '#4CAF50'
}
function reservaActiva(m) {
  return (m.reservas || []).find(r => r.estado === 'pendiente') || null
}
function minutosRestantes(mesa) {
  if (!mesa?.liberar_en) return '—'
  const ms = new Date(mesa.liberar_en) - new Date()
  if (ms <= 0) return 'menos de 1 min'
  return `${Math.ceil(ms / 60000)} min`
}
const tick = ref(0)
function mostrarAviso(texto) {
  avisoTexto.value = texto
  aviso.value = true
}
async function cargar() {
  error.value = null
  try {
    const { data } = await api.get('/mesas')
    mesas.value = data
    tick.value++
  } catch (e) {
    error.value = 'No se pudieron cargar las mesas.'
  }
}
function abrirReserva(mesa) {
  errorForm.value = null
  mesaSeleccionada.value = mesa
  form.value = {
    id_mesa: mesa.id_mesa,
    nombre: '',
    telefono: '',
    fecha: hoyLocal(),
    hora: '',
    personas: 1
  }
  dialogoReserva.value = true
}
async function guardarReserva() {
  errorForm.value = null
  if (!form.value.nombre || !form.value.telefono || !form.value.hora) {
    errorForm.value = 'Completa nombre, teléfono y hora.'
    return
  }
  if (form.value.personas > (mesaSeleccionada.value?.capacidad || 0)) {
    errorForm.value = `La mesa solo admite ${mesaSeleccionada.value.capacidad} personas.`
    return
  }
  guardando.value = true
  try {
    await api.post('/reserva-mesas', form.value)
    dialogoReserva.value = false
    mostrarAviso('Reserva creada. La mesa se libera en 5 minutos.')
    await cargar()
  } catch (e) {
    errorForm.value = e.response?.data?.message || 'No se pudo registrar la reserva.'
  } finally {
    guardando.value = false
  }
}
async function cambiarEstado(mesa, nuevo) {
  if (nuevo === mesa.estado) return
  try {
    await api.put(`/mesas/${mesa.id_mesa}`, { estado: nuevo })
    mostrarAviso(`Mesa ${mesa.id_mesa} ahora está ${nuevo}`)
    await cargar()
  } catch (e) {
    error.value = 'No se pudo cambiar el estado de la mesa.'
  }
}
function verDetalle(mesa) {
  const activa = reservaActiva(mesa)
  detalle.value = {
    titulo: mesa.id_mesa,
    estado: mesa.estado,
    color: colorMesa(mesa),
    filas: [
      { etiqueta: 'Capacidad', valor: `${mesa.capacidad} personas` },
      { etiqueta: 'Ambiente', valor: mesa.ambiente || '—' },
      {
        etiqueta: 'Cliente',
        valor: activa?.cliente?.nombre || 'Sin reserva activa'
      },
      {
        etiqueta: 'Se libera en',
        valor: mesa.liberar_en ? minutosRestantes(mesa) : '—'
      }
    ]
  }
  dialogoDetalle.value = true
}
onMounted(() => {
  cargar()
  intervalo = setInterval(cargar, 15000)
  reloj = setInterval(() => { tick.value++ }, 10000)
})
onUnmounted(() => {
  clearInterval(intervalo)
  clearInterval(reloj)
})
</script>
