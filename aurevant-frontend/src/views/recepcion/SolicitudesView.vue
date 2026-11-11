<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">Solicitudes</h1>
        <p class="text-body-2 text-medium-emphasis">Solicitudes de reserva enviadas por los huéspedes; revísalas y confírmalas.</p>
      </div>
      <v-btn variant="outlined" color="#0F3D2E" prepend-icon="mdi-refresh" @click="cargar">
        Actualizar
      </v-btn>
    </div>
    <v-alert v-if="error" type="error" variant="tonal" class="mb-4">{{ error }}</v-alert>
    <v-card class="pa-4">
      <v-data-table
        :headers="headers"
        :items="solicitudes"
        :loading="cargando"
        loading-text="Cargando solicitudes..."
        no-data-text="No hay solicitudes por ahora."
        density="comfortable"
      >
        <template #item.entrada="{ item }">{{ fecha(item.entrada) }}</template>
        <template #item.salida="{ item }">{{ fecha(item.salida) }}</template>
        <template #item.estado="{ item }">
          <v-chip :color="colorEstado(item.estado)" size="small" variant="flat">
            {{ item.estado }}
          </v-chip>
        </template>
        <template #item.acciones="{ item }">
          <div class="d-flex" style="gap: 8px">
            <v-btn v-if="pendiente(item)" size="small" color="#0F3D2E" rounded="lg"
              @click="aprobar(item)">Aprobar</v-btn>
            <v-btn v-if="pendiente(item)" size="small" color="#B3261E" variant="outlined"
              rounded="lg" @click="abrirRechazo(item)">Rechazar</v-btn>
            <v-btn size="small" variant="text" color="#0F3D2E" @click="verDetalle(item)">Ver</v-btn>
          </div>
        </template>
      </v-data-table>
    </v-card>
    <v-dialog v-model="dialogoRechazo" max-width="460">
      <v-card class="pa-4">
        <h3 class="text-h6 mb-2">Rechazar solicitud</h3>
        <p class="text-body-2 mb-4">Cliente: <strong>{{ seleccionada?.cliente }}</strong></p>
        <v-textarea v-model="motivo" label="Motivo del rechazo" rows="3" variant="outlined"
          hint="El cliente verá este mensaje en la app." persistent-hint />
        <div class="d-flex justify-end mt-4" style="gap: 8px">
          <v-btn variant="text" @click="dialogoRechazo = false">Cancelar</v-btn>
          <v-btn color="#B3261E" :loading="procesando" @click="confirmarRechazo">Rechazar</v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogoDetalle" max-width="520">
      <v-card class="pa-4" v-if="seleccionada">
        <h3 class="text-h6 mb-3">Detalle de la solicitud</h3>
        <v-list density="compact">
          <v-list-item title="Cliente" :subtitle="seleccionada.cliente" />
          <v-list-item title="Teléfono" :subtitle="seleccionada.telefono || '—'" />
          <v-list-item title="Habitación" :subtitle="seleccionada.habitacion || '—'" />
          <v-list-item title="Entrada" :subtitle="fecha(seleccionada.entrada)" />
          <v-list-item title="Salida" :subtitle="fecha(seleccionada.salida)" />
          <v-list-item title="Personas" :subtitle="String(seleccionada.personas || '—')" />
          <v-list-item title="Estado" :subtitle="seleccionada.estado" />
        </v-list>
        <div class="d-flex justify-end">
          <v-btn variant="text" @click="dialogoDetalle = false">Cerrar</v-btn>
        </div>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { listarSolicitudes, aprobarSolicitud, rechazarSolicitud } from '@/services/solicitudesService'
const solicitudes = ref([])
const cargando = ref(false)
const error = ref(null)
const dialogoRechazo = ref(false)
const dialogoDetalle = ref(false)
const seleccionada = ref(null)
const motivo = ref('')
const procesando = ref(false)
const headers = [
  { title: 'Cliente', key: 'cliente' },
  { title: 'Habitación', key: 'habitacion' },
  { title: 'Entrada', key: 'entrada' },
  { title: 'Salida', key: 'salida' },
  { title: 'Personas', key: 'personas' },
  { title: 'Estado', key: 'estado' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const fecha = (f) => {
  if (!f) return '—'
  const [y, m, d] = String(f).slice(0, 10).split('-')
  return `${d}/${m}/${y}`
}
const pendiente = (i) => String(i.estado).toLowerCase() === 'pendiente'
const colorEstado = (e) => {
  const s = String(e || '').toLowerCase()
  if (s === 'pendiente') return 'warning'
  if (s === 'aprobada' || s === 'confirmada') return 'success'
  if (s === 'rechazada' || s === 'cancelada') return 'error'
  return 'grey'
}
async function cargar() {
  cargando.value = true
  error.value = null
  try {
    const { data } = await listarSolicitudes()
    solicitudes.value = data
  } catch (e) {
    error.value = 'No se pudieron cargar las solicitudes. Revisa que la API esté activa.'
    solicitudes.value = []
  } finally {
    cargando.value = false
  }
}
async function aprobar(item) {
  if (!confirm(`¿Aprobar la solicitud de ${item.cliente}?`)) return
  procesando.value = true
  try {
    await aprobarSolicitud(item.id_solicitud || item.id)
    await cargar()
  } catch (e) {
    error.value = e.response?.data?.message || 'No se pudo aprobar la solicitud.'
  } finally {
    procesando.value = false
  }
}
function abrirRechazo(item) {
  seleccionada.value = item
  motivo.value = ''
  dialogoRechazo.value = true
}
async function confirmarRechazo() {
  if (!motivo.value.trim()) return
  procesando.value = true
  try {
    await rechazarSolicitud(seleccionada.value.id_solicitud || seleccionada.value.id, motivo.value)
    dialogoRechazo.value = false
    await cargar()
  } catch (e) {
    error.value = e.response?.data?.message || 'No se pudo rechazar la solicitud.'
  } finally {
    procesando.value = false
  }
}
function verDetalle(item) {
  seleccionada.value = item
  dialogoDetalle.value = true
}
onMounted(cargar)
</script>
