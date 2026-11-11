<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">{{ saludo }}, Recepcionista</h1>
        <p class="text-body-2 text-medium-emphasis">Aquí tienes un resumen de la actividad de hoy en AUREVANT Resort.</p>
      </div>
      <div class="text-right">
        <div class="text-body-2 font-weight-medium">{{ fechaHoy }}</div>
        <div class="text-caption text-medium-emphasis">{{ hora }}</div>
      </div>
    </div>
    <v-row class="mb-2">
      <v-col cols="12" sm="6" md="4">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Habitaciones ocupadas</div>
          <div class="text-h4 font-weight-bold">{{ ocupadasHoy }} / {{ totalHabitaciones }}</div>
          <v-progress-linear :model-value="porcentajeOcupacion" color="#0F3D2E" height="6" rounded class="mt-2" />
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Clientes registrados hoy</div>
          <div class="text-h4 font-weight-bold">{{ kpis.clientes_hoy }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Solicitudes pendientes</div>
          <div class="text-h4 font-weight-bold">{{ kpis.solicitudes_pendientes }}</div>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="8">
        <v-card class="pa-4 mb-4">
          <div class="d-flex justify-space-between align-center mb-3">
            <h3 class="text-subtitle-1 font-weight-bold">Reservaciones</h3>
            <v-btn variant="text" size="small" color="#0F3D2E" to="/recepcion/reservas">Ver todas →</v-btn>
          </div>
          <div v-if="recientes.length" class="d-flex flex-column" style="gap: 10px">
            <div v-for="r in recientes" :key="r.id_reserva || r.id" class="mini-card">
              <div class="mini-stripe" :style="{ background: colorEstado(r.estado) }" />
              <div class="flex-grow-1">
                <div class="d-flex align-center flex-wrap" style="gap: 6px">
                  <span class="mini-name">{{ r.cliente?.nombre || r.cliente || '—' }}</span>
                  <v-chip size="x-small" variant="flat" :color="colorEstado(r.estado)">
                    {{ r.estado }}
                  </v-chip>
                </div>
                <div class="mini-meta">
                  Hab. {{ r.habitacion?.numero || r.habitacion || '—' }}
                  · {{ fecha(r.fecha_inicio) }} → {{ fecha(r.fecha_fin) }}
                  · {{ noches(r) }}
                </div>
              </div>
              <v-btn size="small" color="#0F3D2E" rounded="lg" @click="verDetalle(r)">Ver</v-btn>
            </div>
          </div>
          <p v-else class="text-body-2 text-medium-emphasis mb-0">No hay reservaciones registradas.</p>
        </v-card>
        <v-row>
          <v-col cols="12" sm="6">
            <v-card class="pa-4">
              <h3 class="text-subtitle-1 font-weight-bold mb-3">Check-in de hoy</h3>
              <v-list density="compact">
                <v-list-item v-for="r in checkins" :key="r.id_reserva || r.id">
                  <v-list-item-title>{{ r.cliente?.nombre || r.cliente }}</v-list-item-title>
                  <v-list-item-subtitle>Hab. {{ r.habitacion?.numero || r.habitacion }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
              <p v-if="!checkins.length" class="text-body-2 text-medium-emphasis mb-0">Sin check-ins pendientes.</p>
            </v-card>
          </v-col>
          <v-col cols="12" sm="6">
            <v-card class="pa-4">
              <h3 class="text-subtitle-1 font-weight-bold mb-3">Check-out de hoy</h3>
              <v-list density="compact">
                <v-list-item v-for="r in checkouts" :key="r.id_reserva || r.id">
                  <v-list-item-title>{{ r.cliente?.nombre || r.cliente }}</v-list-item-title>
                  <v-list-item-subtitle>Hab. {{ r.habitacion?.numero || r.habitacion }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
              <p v-if="!checkouts.length" class="text-body-2 text-medium-emphasis mb-0">Sin check-outs pendientes.</p>
            </v-card>
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="12" md="4">
        <v-card class="pa-4 mb-4">
          <h3 class="text-subtitle-1 font-weight-bold mb-3">Estado de habitaciones</h3>
          <div class="d-flex justify-center mb-4">
            <div class="dona-wrap" :style="{ background: pastelGradient }">
              <div class="dona-hole">
                <div class="text-h5 font-weight-bold">{{ totalHabitaciones }}</div>
                <div class="text-caption text-medium-emphasis">Total</div>
              </div>
            </div>
          </div>
          <div v-for="e in estadosHabLista" :key="e.label" class="leyenda-row">
            <span class="dot" :style="{ background: e.color }" />
            <span class="flex-grow-1 text-body-2">{{ e.label }}</span>
            <span class="text-body-2 font-weight-bold">{{ e.value }}</span>
          </div>
        </v-card>
        <v-card class="pa-4">
          <div class="d-flex justify-space-between align-center mb-3">
            <h3 class="text-subtitle-1 font-weight-bold">Próximas reservaciones</h3>
            <v-chip size="x-small" color="#C9A227" variant="flat">{{ proximas.length }}</v-chip>
          </div>
          <div v-if="proximas.length" class="d-flex flex-column" style="gap: 10px">
            <div v-for="r in proximas" :key="r.id_reserva || r.id" class="mini-card">
              <div class="mini-stripe" :style="{ background: colorEstado(r.estado) }" />
              <div class="flex-grow-1">
                <div class="d-flex align-center flex-wrap" style="gap: 6px">
                  <span class="mini-name">{{ r.cliente?.nombre || r.cliente || '—' }}</span>
                  <v-chip size="x-small" variant="outlined" color="#0F3D2E">
                    en {{ diasPara(r.fecha_inicio) }}
                  </v-chip>
                </div>
                <div class="mini-meta">
                  Hab. {{ r.habitacion?.numero || r.habitacion || '—' }}
                  · {{ fecha(r.fecha_inicio) }} → {{ fecha(r.fecha_fin) }}
                  · {{ noches(r) }}
                </div>
              </div>
            </div>
          </div>
          <p v-else class="text-body-2 text-medium-emphasis mb-0">No hay reservaciones próximas.</p>
        </v-card>
      </v-col>
    </v-row>
    <v-dialog v-model="dialogoDetalle" max-width="460">
      <v-card rounded="xl" class="overflow-hidden">
        <div class="pa-5" style="background:#0F3D2E; color:#F5EFE0">
          <div class="d-flex justify-space-between align-center">
            <div>
              <div class="text-caption" style="opacity:.75">Reservación</div>
              <div class="text-h6 font-weight-bold">#{{ detalle?.id_reserva || detalle?.id }}</div>
            </div>
            <v-chip :color="colorEstado(detalle?.estado)" variant="flat" size="small">
              {{ detalle?.estado }}
            </v-chip>
          </div>
          <div class="text-body-2 mt-2">{{ detalle?.cliente?.nombre || detalle?.cliente }}</div>
        </div>
        <v-card-text class="pa-5">
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Habitación</span>
            <span class="font-weight-medium">{{ detalle?.habitacion?.numero || detalle?.habitacion }}</span>
          </div>
          <v-divider />
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Entrada</span>
            <span class="font-weight-medium">{{ fecha(detalle?.fecha_inicio) }}</span>
          </div>
          <v-divider />
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Salida</span>
            <span class="font-weight-medium">{{ fecha(detalle?.fecha_fin) }}</span>
          </div>
          <v-divider />
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Noches</span>
            <span class="font-weight-medium">{{ noches(detalle || {}) || '—' }}</span>
          </div>
        </v-card-text>
        <v-card-actions class="px-5 pb-4">
          <v-spacer />
          <v-btn variant="text" @click="dialogoDetalle = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { obtenerDashboard } from '@/services/dashboardService'
const cargando = ref(true)
const error = ref(null)
const reservas = ref([])
const checkins = ref([])
const checkouts = ref([])
const proximas = ref([])
const dialogoDetalle = ref(false)
const detalle = ref(null)
const kpis = ref({
  habitaciones_total: 0,
  clientes_hoy: 0,
  solicitudes_pendientes: 0
})
const estadoHab = ref({
  disponibles: 0,
  ocupadas: 0,
  mantenimiento: 0,
  limpieza: 0
})
const saludo = computed(() => {
  const h = new Date().getHours()
  if (h < 12) return '¡Buenos días'
  if (h < 19) return '¡Buenas tardes'
  return '¡Buenas noches'
})
const fechaHoy = computed(() =>
  new Date().toLocaleDateString('es-SV', { day: 'numeric', month: 'long', year: 'numeric' })
)
const hora = computed(() =>
  new Date().toLocaleTimeString('es-SV', { hour: '2-digit', minute: '2-digit' })
)
const soloFecha = (f) => (f ? String(f).slice(0, 10) : '')
const hoyStr = () => {
  const d = new Date()
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}
function fecha(valor) {
  const s = soloFecha(valor)
  if (!s) return '—'
  const [y, m, d] = s.split('-')
  return `${d}/${m}/${y}`
}
function noches(r) {
  if (!r) return ''
  const ini = soloFecha(r.fecha_inicio)
  const fin = soloFecha(r.fecha_fin)
  if (!ini || !fin) return ''
  const n = Math.round((new Date(fin + 'T00:00:00') - new Date(ini + 'T00:00:00')) / 86400000)
  return n > 0 ? `${n} ${n === 1 ? 'noche' : 'noches'}` : ''
}
function diasPara(f) {
  const s = soloFecha(f)
  if (!s) return '—'
  const d = Math.round((new Date(s + 'T00:00:00') - new Date(hoyStr() + 'T00:00:00')) / 86400000)
  if (d <= 0) return 'hoy'
  if (d === 1) return 'mañana'
  return `${d} días`
}
function colorEstado(estado) {
  const e = (estado || '').toLowerCase()
  if (e === 'confirmada') return '#0F3D2E'
  if (e === 'pendiente') return '#D4B483'
  if (e === 'ocupada') return '#1E5B44'
  if (e === 'cancelada') return '#C0392B'
  if (e === 'finalizada') return '#7F8C8D'
  return 'grey'
}
const reservasActivasHoy = computed(() => {
  const hoy = hoyStr()
  return reservas.value.filter((r) => {
    const ini = soloFecha(r.fecha_inicio)
    const fin = soloFecha(r.fecha_fin)
    const e = (r.estado || '').toLowerCase()
    const vigente = e === 'confirmada' || e === 'ocupada' || e === 'check-in'
    return vigente && ini && fin && ini <= hoy && hoy <= fin
  })
})
const ocupadasHoy = computed(() => reservasActivasHoy.value.length)
const totalHabitaciones = computed(() => kpis.value.habitaciones_total || 0)
const porcentajeOcupacion = computed(() => {
  if (!totalHabitaciones.value) return 0
  return (ocupadasHoy.value / totalHabitaciones.value) * 100
})
const recientes = computed(() => {
  return [...reservas.value]
    .sort((a, b) => String(soloFecha(b.fecha_inicio) || '').localeCompare(String(soloFecha(a.fecha_inicio) || '')))
    .slice(0, 4)
})
const estadosHabLista = computed(() => {
  const ocupadas = ocupadasHoy.value
  const mantenimiento = estadoHab.value.mantenimiento || 0
  const limpieza = estadoHab.value.limpieza || 0
  const disponibles = Math.max(totalHabitaciones.value - ocupadas - mantenimiento - limpieza, 0)
  return [
    { label: 'Disponibles', value: disponibles, color: '#0F3D2E' },
    { label: 'Ocupadas', value: ocupadas, color: '#D4B483' },
    { label: 'Mantenimiento', value: mantenimiento, color: '#C9C2B4' },
    { label: 'Limpieza', value: limpieza, color: '#8A8A8A' }
  ]
})
const pastelGradient = computed(() => {
  const total = estadosHabLista.value.reduce((s, e) => s + e.value, 0)
  if (!total) return '#F0EBE0'
  let acumulado = 0
  const partes = estadosHabLista.value.map((e) => {
    const desde = (acumulado / total) * 100
    acumulado += e.value
    const hasta = (acumulado / total) * 100
    return `${e.color} ${desde}% ${hasta}%`
  })
  return `conic-gradient(${partes.join(', ')})`
})
function verDetalle(r) {
  detalle.value = r
  dialogoDetalle.value = true
}
async function cargar() {
  cargando.value = true
  error.value = null
  try {
    const { data } = await obtenerDashboard()
    kpis.value = { ...kpis.value, ...(data.kpis || {}) }
    estadoHab.value = { ...estadoHab.value, ...(data.estado_habitaciones || {}) }
    reservas.value = data.reservaciones || data.reservas || []
    checkins.value = data.checkins || []
    checkouts.value = data.checkouts || []
    proximas.value = data.proximas || []
  } catch (e) {
    error.value = 'No se pudo cargar el dashboard.'
    console.error('Error al cargar el dashboard', e)
  } finally {
    cargando.value = false
  }
}
let intervalo = null
const alVolver = () => { if (document.visibilityState === 'visible') cargar() }
onMounted(() => {
  cargar()
  intervalo = setInterval(cargar, 30000)
  document.addEventListener('visibilitychange', alVolver)
})
onUnmounted(() => {
  if (intervalo) clearInterval(intervalo)
  document.removeEventListener('visibilitychange', alVolver)
})
</script>
<style scoped>
.kpi {
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  background: #FFFFFF;
}
.dona-wrap {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.dona-hole {
  width: 92px;
  height: 92px;
  border-radius: 50%;
  background: #FFFFFF;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.leyenda-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 0;
  border-bottom: 1px solid rgba(212, 180, 131, 0.25);
}
.leyenda-row:last-child { border-bottom: none; }
.dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; }
.mini-card {
  position: relative;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px 10px 16px;
  border: 1px solid rgba(212, 180, 131, 0.4);
  border-radius: 10px;
  background: #FFFFFF;
  transition: box-shadow 0.15s, transform 0.15s;
}
.mini-card:hover {
  box-shadow: 0 2px 8px rgba(15, 61, 46, 0.08);
  transform: translateY(-1px);
}
.mini-stripe {
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 4px;
  border-top-left-radius: 10px;
  border-bottom-left-radius: 10px;
}
.mini-name { font-size: 14px; font-weight: 600; color: #1A1A1A; }
.mini-meta { font-size: 12px; color: #8A8A8A; margin-top: 2px; }
</style>
