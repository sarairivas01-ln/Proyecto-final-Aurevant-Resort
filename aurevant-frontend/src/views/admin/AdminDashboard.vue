<template>
  <div>
¿    <div class="d-flex justify-space-between align-start mb-6">
      <div>
        <h2 class="page-title">¡Bienvenido, Administrador!</h2>
        <p class="page-sub">Gestiona las habitaciones, platillos y reservaciones de AUREVANT Resort.</p>
      </div>
      <div class="text-right">
        <div class="fecha">{{ fecha }}</div>
        <div class="hora">{{ hora }}</div>
      </div>
    </div>
¿    <v-row dense class="mb-4">
      <v-col cols="12" sm="6" md="4">
        <StatCard
          icon="mdi-bed-outline"
          label="Habitaciones totales"
          :value="totalHabitaciones"
          :hint="`● ${disponibles} disponibles`"
        />
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <StatCard
          icon="mdi-silverware-fork-knife"
          label="Platillos activos"
          :value="platillosActivos"
          :hint="`● ${platillosDesactivados} desactivados`"
        />
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <StatCard
          icon="mdi-account-group-outline"
          label="Clientes este mes"
          :value="clientesMes"
          hint="Registrados en el sistema"
        />
      </v-col>
    </v-row>
    <v-row dense>
      <v-col cols="12" md="8">
        <v-card class="panel mb-4" elevation="0">
          <div class="panel-head">
            <span class="panel-title">Reservaciones recientes</span>
            <v-btn
              variant="text"
              size="small"
              color="#0F3D2E"
              append-icon="mdi-arrow-right"
              @click="$router.push('/admin/reservaciones')"
            >Ver todas</v-btn>
          </div>
          <v-data-table
            :headers="headersReservas"
            :items="reservasRecientes"
            :loading="cargandoReservas"
            loading-text="Cargando reservaciones..."
            density="comfortable"
            :items-per-page="-1"
            hide-default-footer
            class="tabla-aurevant"
            no-data-text="No hay reservaciones registradas."
          >
            <template #item.fecha_inicio="{ item }">{{ formatearFecha(item.fecha_inicio) }}</template>
            <template #item.fecha_fin="{ item }">{{ formatearFecha(item.fecha_fin) }}</template>
            <template #item.estado="{ item }">
              <v-chip :color="colorEstado(item.estado)" size="small" variant="flat">{{ item.estado }}</v-chip>
            </template>
            <template #item.acciones="{ item }">
              <v-btn
                size="small"
                color="#0F3D2E"
                variant="flat"
                rounded="lg"
                @click="verReserva(item)"
              >Ver</v-btn>
            </template>
          </v-data-table>
        </v-card>
        <v-card class="panel mb-4" elevation="0">
          <div class="panel-head">
            <span class="panel-title">Clientes recientes</span>
            <v-btn
              variant="text"
              size="small"
              color="#0F3D2E"
              append-icon="mdi-arrow-right"
              @click="$router.push('/admin/clientes')"
            >Ver todos</v-btn>
          </div>
          <v-data-table
            :headers="headersClientes"
            :items="clientesRecientes"
            :loading="cargandoClientes"
            loading-text="Cargando clientes..."
            density="comfortable"
            :items-per-page="-1"
            hide-default-footer
            class="tabla-aurevant"
            no-data-text="No hay clientes registrados."
          >
            <template #item.nombre="{ item }">
              <div>
                <div class="cli-nombre">{{ item.nombre }}</div>
                <div class="cli-sub">{{ item.email || 'Sin correo' }}</div>
              </div>
            </template>
            <template #item.DUI="{ item }">
              <span :class="item.DUI ? '' : 'cli-sub'">{{ item.DUI || 'Sin DUI' }}</span>
            </template>
            <template #item.acciones="{ item }">
              <v-btn
                size="small"
                color="#0F3D2E"
                variant="flat"
                rounded="lg"
                @click="verCliente(item)"
              >Ver</v-btn>
            </template>
          </v-data-table>
        </v-card>
        <v-card class="panel" elevation="0">
          <div class="panel-head">
            <span class="panel-title">Platillos</span>
            <v-btn
              variant="text"
              size="small"
              color="#0F3D2E"
              append-icon="mdi-arrow-right"
              @click="$router.push('/admin/platillos')"
            >Ver todos</v-btn>
          </div>
          <v-data-table
            :headers="headersPlatillos"
            :items="platillosVisibles"
            :loading="cargandoPlatillos"
            loading-text="Cargando platillos..."
            density="comfortable"
            :items-per-page="-1"
            hide-default-footer
            class="tabla-aurevant"
            no-data-text="No hay platillos registrados."
          >
            <template #item.img="{ item }">
              <v-avatar size="36" rounded="lg" class="my-1">
                <v-img :src="urlImagen(item.img)" cover />
              </v-avatar>
            </template>
            <template #item.precio="{ item }">
              ${{ Number(item.precio).toFixed(2) }}
            </template>
            <template #item.activo="{ item }">
              <v-chip :color="item.activo ? 'success' : 'grey'" size="small" variant="flat">
                {{ item.activo ? 'Activo' : 'Desactivado' }}
              </v-chip>
            </template>
            <template #item.acciones="{ item }">
              <v-btn
                size="small"
                color="#0F3D2E"
                variant="flat"
                rounded="lg"
                @click="$router.push('/admin/platillos')"
              >Ver</v-btn>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
      <!-- Columna derecha -->
      <v-col cols="12" md="4">
        <v-card class="panel mb-4" elevation="0">
          <div class="panel-head">
            <span class="panel-title">Estado de habitaciones</span>
          </div>
          <div class="d-flex align-center">
            <v-progress-circular
              :model-value="porcentajeDisponible"
              :size="110"
              :width="14"
              color="#0F3D2E"
              bg-color="#E9E1D2"
            >
              <div class="text-center">
                <div class="dona-num">{{ totalHabitaciones }}</div>
                <div class="dona-lbl">Total</div>
              </div>
            </v-progress-circular>
            <v-list density="compact" class="ml-4 flex-grow-1">
              <v-list-item v-for="e in estados" :key="e.label">
                <template #prepend>
                  <span class="dot" :style="{ background: e.color }" />
                </template>
                <v-list-item-title class="text-body-2">{{ e.label }}</v-list-item-title>
                <template #append>{{ e.value }}</template>
              </v-list-item>
            </v-list>
          </div>
        </v-card>
        <v-card class="panel mb-4" elevation="0">
          <div class="panel-head">
            <span class="panel-title">Habitaciones destacadas</span>
          </div>
          <v-row dense>
            <v-col v-if="destacadas.length === 0" cols="12">
              <p class="text-caption text-medium-emphasis text-center py-4">
                No hay habitaciones disponibles por ahora.
              </p>
            </v-col>
            <v-col v-for="h in destacadas" :key="h.id_habitacion" cols="12" sm="4">
              <v-card
                class="mini"
                elevation="0"
                style="cursor: pointer"
                @click="verHabitacion(h)"
              >
                <v-img :src="urlImagen(h.img)" height="70" cover>
                  <v-chip
                    size="x-small"
                    :color="h.activa ? colorHabitacion(h.estado) : 'error'"
                    class="ma-1"
                  >
                    {{ h.activa ? h.estado : 'Inactiva' }}
                  </v-chip>
                </v-img>
                <div class="pa-2">
                  <div class="mini-title">Hab. {{ h.numero }}</div>
                  <div class="mini-price">
                    ${{ Number(h.precio_noche).toFixed(2) }} <span>/noche</span>
                  </div>
                  <div class="mini-meta">{{ h.capacidad }} pers. · {{ h.vista }}</div>
                </div>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>
<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import StatCard from '@/components/StatCard.vue'
import { listarPlatillos } from '@/services/platillosService'
import { listarReservas } from '@/services/reservasService'
import { listarHabitaciones } from '@/services/habitacionesService'
import { listarClientes } from '@/services/clientesService'
const router = useRouter()
const API_BASE = 'http://localhost:8000'
function urlImagen(ruta) {
  if (!ruta) return ''
  if (ruta.startsWith('http') || ruta.startsWith('blob:')) return ruta
  if (ruta.startsWith('/storage/')) return `${API_BASE}${ruta}`
  return `${API_BASE}/storage/${ruta}`
}
const ahora = new Date()
const fecha = ahora.toLocaleDateString('es-ES', { day: 'numeric', month: 'long', year: 'numeric' })
const hora = ahora.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' })
const headersReservas = [
  { title: 'Cliente', key: 'cliente' },
  { title: 'Habitación', key: 'habitacion' },
  { title: 'Entrada', key: 'fecha_inicio' },
  { title: 'Salida', key: 'fecha_fin' },
  { title: 'Estado', key: 'estado' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const reservas = ref([])
const cargandoReservas = ref(false)
const reservasRecientes = computed(() =>
  [...reservas.value]
    .sort((a, b) => Number(b.id_reserva ?? 0) - Number(a.id_reserva ?? 0))
    .slice(0, 4)
)
const hoy = new Date().toISOString().slice(0, 10)
const reservasHoy = computed(
  () => reservas.value.filter(r => String(r.fecha_inicio).slice(0, 10) === hoy).length
)
const reservasPendientes = computed(
  () => reservas.value.filter(r => String(r.estado).toLowerCase() === 'pendiente').length
)
function formatearFecha(f) {
  if (!f) return '—'
  const limpia = String(f).slice(0, 10)
  const [y, m, d] = limpia.split('-')
  return `${d}/${m}/${y}`
}
function colorEstado(e) {
  const estado = String(e || '').toLowerCase()
  if (estado === 'confirmada') return 'success'
  if (estado === 'pendiente') return 'warning'
  if (estado === 'cancelada') return 'error'
  return 'grey'
}
function verReserva(item) {
  router.push({ path: '/admin/reservaciones', query: { cliente: item.cliente } })
}
async function cargarReservas() {
  cargandoReservas.value = true
  try {
    const { data } = await listarReservas()
    reservas.value = Array.isArray(data) ? data : (data.data ?? [])
  } catch (e) {
    reservas.value = []
  } finally {
    cargandoReservas.value = false
  }
}
const headersClientes = [
  { title: 'Cliente', key: 'nombre' },
  { title: 'Teléfono', key: 'telefono' },
  { title: 'DUI', key: 'DUI' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const clientes = ref([])
const cargandoClientes = ref(false)
const clientesMes = computed(() => clientes.value.length)
/* Solo los 4 más recientes */
const clientesRecientes = computed(() =>
  [...clientes.value]
    .sort((a, b) => Number(b.id_cliente ?? 0) - Number(a.id_cliente ?? 0))
    .slice(0, 4)
)
async function cargarClientes() {
  cargandoClientes.value = true
  try {
    const { data } = await listarClientes()
    clientes.value = Array.isArray(data) ? data : (data.data ?? [])
  } catch (e) {
    clientes.value = []
  } finally {
    cargandoClientes.value = false
  }
}
function verCliente(item) {
  const id = item.id_cliente ?? item.id
  router.push({ path: '/admin/clientes', query: { id } })
}
const headersPlatillos = [
  { title: 'Imagen', key: 'img', sortable: false },
  { title: 'Nombre', key: 'nombre' },
  { title: 'Categoría', key: 'categoria' },
  { title: 'Precio', key: 'precio' },
  { title: 'Estado', key: 'activo' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const platillos = ref([])
const cargandoPlatillos = ref(false)
const platillosActivos = computed(
  () => platillos.value.filter(p => p.activo).length
)
const platillosDesactivados = computed(
  () => platillos.value.filter(p => !p.activo).length
)
const platillosVisibles = computed(() =>
  platillos.value
    .filter(p => p.activo)
    .sort((a, b) => Number(b.id_platillo ?? 0) - Number(a.id_platillo ?? 0))
    .slice(0, 4)
)
async function cargarPlatillos() {
  cargandoPlatillos.value = true
  try {
    const { data } = await listarPlatillos()
    platillos.value = Array.isArray(data) ? data : (data.data ?? [])
  } catch (e) {
    platillos.value = []
  } finally {
    cargandoPlatillos.value = false
  }
}
const habitaciones = ref([])
const totalHabitaciones = computed(() => habitaciones.value.length)
const disponibles = computed(
  () => habitaciones.value.filter(h => h.activa && h.estado === 'Disponible').length
)
const ocupadas = computed(
  () => habitaciones.value.filter(h => h.activa && h.estado === 'Ocupada').length
)
const enMantenimiento = computed(
  () => habitaciones.value.filter(h => h.activa && h.estado === 'Mantenimiento').length
)
const inactivas = computed(
  () => habitaciones.value.filter(h => !h.activa).length
)
const porcentajeDisponible = computed(() =>
  totalHabitaciones.value
    ? Math.round((disponibles.value / totalHabitaciones.value) * 100)
    : 0
)
const estados = computed(() => [
  { label: 'Disponibles', value: disponibles.value, color: '#0F3D2E' },
  { label: 'Ocupadas', value: ocupadas.value, color: '#D4B483' },
  { label: 'Mantenimiento', value: enMantenimiento.value, color: '#C9C2B4' },
  { label: 'Inactivas', value: inactivas.value, color: '#B0B0B0' }
])
const destacadas = computed(() =>
  habitaciones.value
    .filter(h => h.activa && h.estado === 'Disponible')
    .sort((a, b) => Number(b.precio_noche) - Number(a.precio_noche))
    .slice(0, 3)
)
function colorHabitacion(e) {
  if (e === 'Disponible') return 'success'
  if (e === 'Ocupada') return 'warning'
  if (e === 'Mantenimiento') return 'grey'
  return 'error'
}
function verHabitacion(h) {
  router.push({ path: '/admin/habitaciones', query: { numero: h.numero } })
}
async function cargarHabitaciones() {
  try {
    const { data } = await listarHabitaciones()
    habitaciones.value = Array.isArray(data) ? data : (data.data ?? [])
  } catch (e) {
    habitaciones.value = []
  }
}
function cargarTodo() {
  cargarPlatillos()
  cargarReservas()
  cargarHabitaciones()
  cargarClientes()
}
let intervalo = null
function alVolverALaPestana() {
  if (document.visibilityState === 'visible') cargarTodo()
}
onMounted(() => {
  cargarTodo()
  intervalo = setInterval(cargarTodo, 30000) 
  document.addEventListener('visibilitychange', alVolverALaPestana)
})
onUnmounted(() => {
  if (intervalo) clearInterval(intervalo)
  document.removeEventListener('visibilitychange', alVolverALaPestana)
})
</script>
<style scoped>
.page-title { font-family: 'Cormorant Garamond', serif; font-size: 26px; color: #1A1A1A; }
.page-sub { font-size: 13px; color: #6B6B6B; }
.fecha { font-size: 13px; color: #1A1A1A; font-weight: 500; }
.hora { font-size: 11px; color: #8A8A8A; }
.panel {
  background: #FFFFFF;
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  padding: 16px;
}
.panel-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}
.panel-title { font-size: 15px; font-weight: 600; color: #1A1A1A; }
.dona-num { font-size: 20px; font-weight: 600; color: #1A1A1A; }
.dona-lbl { font-size: 10px; color: #8A8A8A; }
.dot { display: inline-block; width: 9px; height: 9px; border-radius: 50%; margin-right: 8px; }
.mini { border: 1px solid rgba(212, 180, 131, 0.4); border-radius: 10px; overflow: hidden; }
.mini-title { font-size: 11px; font-weight: 600; color: #1A1A1A; }
.mini-price { font-size: 12px; color: #0F3D2E; font-weight: 600; }
.mini-price span { font-size: 9px; color: #8A8A8A; font-weight: 400; }
.mini-meta { font-size: 9px; color: #8A8A8A; }
.cli-nombre { font-size: 13px; font-weight: 500; color: #1A1A1A; }
.cli-sub { font-size: 11px; color: #8A8A8A; }
</style>
