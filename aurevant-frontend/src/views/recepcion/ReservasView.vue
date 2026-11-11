<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">Reservaciones</h1>
        <p class="text-body-2 text-medium-emphasis">Gestión de reservas del hotel.</p>
      </div>
      <v-btn color="#0F3D2E" prepend-icon="mdi-plus" @click="abrirNueva">Nueva reservación</v-btn>
    </div>
    <v-alert v-if="error" type="error" variant="tonal" class="mb-4">{{ error }}</v-alert>
    <v-card class="pa-3 mb-4">
      <div class="d-flex justify-space-between align-center mb-3 flex-wrap" style="gap: 12px">
        <div class="d-flex align-center" style="gap: 8px">
          <v-btn icon="mdi-chevron-left" variant="text" size="small" @click="moverMes(-1)" />
          <span class="text-subtitle-1 font-weight-bold" style="min-width: 170px; text-align: center">
            {{ tituloMes }}
          </span>
          <v-btn icon="mdi-chevron-right" variant="text" size="small" @click="moverMes(1)" />
          <v-btn variant="text" size="small" color="#0F3D2E" @click="irHoy">Hoy</v-btn>
        </div>
        <v-btn-toggle v-model="vista" mandatory density="compact" color="#0F3D2E" variant="outlined">
          <v-btn value="mes" size="small">Mes</v-btn>
          <v-btn value="semana" size="small">Semana</v-btn>
          <v-btn value="dia" size="small">Día</v-btn>
        </v-btn-toggle>
      </div>
      <div class="cal-grid cal-head" :style="{ '--cols': cols }">
        <div v-for="d in diasCabecera" :key="d.key" class="cal-head-cell">
          <div class="cal-head-day">{{ d.label }}</div>
          <div class="cal-head-num">{{ d.num }}</div>
        </div>
      </div>
      <div class="cal-body" :style="{ '--cols': cols, '--filas': filas }">
        <div class="cal-grid cal-fondo">
          <div
            v-for="(celda, idx) in celdas"
            :key="'c' + idx"
            class="cal-cell"
            :class="{ 'cal-out': !celda.enMes, 'cal-today': celda.esHoy }"
            @click="abrirNuevaEnFecha(celda.fecha)"
          >
            <div class="cal-day-num">{{ celda.dia }}</div>
          </div>
        </div>
        <div class="cal-grid cal-barras">
          <div
            v-for="b in barras"
            :key="b.id"
            class="cal-bar"
            :class="{ 'bar-izq': b.continuaIzq, 'bar-der': b.continuaDer }"
            :style="{
              gridColumn: `${b.colInicio} / ${b.colFin}`,
              gridRow: b.fila,
              background: colorBarra(b.estado),
              marginTop: `${22 + b.carril * 17}px`
            }"
            :title="`#${b.idReserva} · ${b.habitacion} · ${b.cliente} · ${fecha(b.entrada)} → ${fecha(b.salida)}`"
            @click.stop="verDetallePorId(b.idReserva)"
          >
            {{ b.habitacion }} · hasta {{ fecha(b.salida) }}
          </div>
        </div>
      </div>
      <div class="d-flex flex-wrap mt-3" style="gap: 16px">
        <div v-for="e in ESTADOS" :key="e" class="d-flex align-center" style="gap: 6px">
          <span class="cal-dot" :style="{ background: colorBarra(e) }" />
          <span class="text-caption">{{ e }}</span>
        </div>
      </div>
    </v-card>
    <v-card class="pa-4">
      <v-data-table
        item-value="id_reserva"
        :headers="headers"
        :items="reservas"
        :loading="cargando"
        loading-text="Cargando reservaciones..."
        no-data-text="No hay reservaciones registradas."
        density="comfortable"
      >
        <template #item.entrada="{ item }">{{ fecha(item.entrada) }}</template>
        <template #item.salida="{ item }">{{ fecha(item.salida) }}</template>
        <template #item.estado="{ item }">
          <v-chip :color="colorEstado(item.estado)" size="small" variant="flat">{{ item.estado }}</v-chip>
        </template>
        <template #item.acciones="{ item }">
          <div class="d-flex" style="gap: 8px">
            <v-btn size="small" color="#0F3D2E" rounded="lg" @click="verDetalle(item)">Ver</v-btn>
            <v-btn size="small" variant="outlined" color="#0F3D2E" rounded="lg"
              prepend-icon="mdi-pencil" @click="editar(item)">Editar</v-btn>
          </div>
        </template>
      </v-data-table>
    </v-card>
    <v-dialog v-model="dialogoDetalle" max-width="480">
      <v-card rounded="xl" class="overflow-hidden">
        <div class="pa-5" style="background:#0F3D2E; color:#F5EFE0">
          <div class="d-flex justify-space-between align-center">
            <div>
              <div class="text-caption" style="opacity:.75">Reservación</div>
              <div class="text-h6 font-weight-bold">#{{ detalle?.id_reserva }}</div>
            </div>
            <v-chip :color="colorEstado(detalle?.estado)" variant="flat" size="small">
              {{ detalle?.estado }}
            </v-chip>
          </div>
          <div class="text-body-2 mt-2">{{ detalle?.cliente }}</div>
        </div>
        <v-card-text class="pa-5">
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Habitación</span>
            <span class="font-weight-medium">{{ detalle?.habitacion }}</span>
          </div>
          <v-divider />
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Entrada</span>
            <span class="font-weight-medium">{{ fecha(detalle?.entrada) }}</span>
          </div>
          <v-divider />
          <div class="d-flex justify-space-between py-2">
            <span class="text-medium-emphasis">Salida</span>
            <span class="font-weight-medium">{{ fecha(detalle?.salida) }}</span>
          </div>
        </v-card-text>
        <v-card-actions class="px-5 pb-4">
          <v-spacer />
          <v-btn variant="text" @click="dialogoDetalle = false">Cerrar</v-btn>
          <v-btn color="#0F3D2E" @click="editarDesdeDetalle">Editar fechas</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogo" max-width="560">
      <v-card class="pa-4" style="position: relative; overflow: visible">
        <h3 class="text-h6 mb-4">{{ editando ? 'Editar reservación' : 'Nueva reservación' }}</h3>
        <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-3">
          {{ error }}
        </v-alert>
        <v-select v-model="form.id_cliente" :items="clientes" item-title="nombre"
          item-value="id_cliente" label="Cliente" variant="outlined" density="comfortable" />
        <v-select v-model="form.id_habitacion" :items="habitaciones" item-title="numero"
          item-value="id_habitacion" label="Habitación" variant="outlined" density="comfortable" />
        <v-text-field v-model="form.fecha_inicio" type="date" label="Entrada" variant="outlined" density="comfortable" />
        <v-text-field v-model="form.fecha_fin" type="date" label="Salida" variant="outlined" density="comfortable"
          :min="form.fecha_inicio || undefined" />
        <v-select
          v-model="form.estado"
          :items="ESTADOS"
          label="Estado"
          variant="outlined"
          density="comfortable"
          :menu-props="{ location: 'bottom', offset: 4 }"
        />
        <div class="d-flex justify-end mt-2" style="gap: 8px">
          <v-btn variant="text" @click="dialogo = false">Cancelar</v-btn>
          <v-btn color="#0F3D2E" :loading="guardando" @click="guardar">Guardar</v-btn>
        </div>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { listarReservaciones, crearReservacion, actualizarReservacion } from '@/services/reservasService'
import { listarClientes } from '@/services/clientesService'
import { listarHabitaciones } from '@/services/habitacionesService'
const reservas = ref([])
const clientes = ref([])
const habitaciones = ref([])
const cargando = ref(false)
const guardando = ref(false)
const error = ref(null)
const dialogo = ref(false)
const editando = ref(null)
const form = ref({})
const dialogoDetalle = ref(false)
const detalle = ref(null)
const headers = [
  { title: 'Cliente', key: 'cliente' },
  { title: 'Habitación', key: 'habitacion' },
  { title: 'Entrada', key: 'entrada' },
  { title: 'Salida', key: 'salida' },
  { title: 'Estado', key: 'estado' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const vista = ref('mes')
const hoy = new Date()
const cursor = ref(new Date(hoy.getFullYear(), hoy.getMonth(), 1))
const ESTADOS = ['Pendiente', 'Confirmada', 'Cancelada', 'Finalizada']
const MESES = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]
const MESES_CORTOS = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
]
const DIAS_CORTOS = ['DOM', 'LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB']
const soloFecha = (f) => (f ? String(f).slice(0, 10) : null)
const fecha = (f) => {
  const s = soloFecha(f)
  if (!s) return '—'
  const [y, m, d] = s.split('-')
  return `${d}/${m}/${y}`
}
const ymd = (d) => {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${dd}`
}
const mismoDia = (a, b) => ymd(a) === ymd(b)
const sumarDias = (d, n) => {
  const c = new Date(d)
  c.setDate(c.getDate() + n)
  return c
}
const colorEstado = (e) => {
  const s = String(e || '').toLowerCase()
  if (s === 'pendiente') return 'warning'
  if (s === 'confirmada') return 'success'
  if (s === 'cancelada') return 'error'
  if (s === 'finalizada') return 'grey'
  return 'grey'
}
const colorBarra = (e) => {
  const s = String(e || '').toLowerCase()
  if (s === 'pendiente') return '#C9A227'
  if (s === 'confirmada') return '#0F3D2E'
  if (s === 'cancelada') return '#B3261E'
  if (s === 'finalizada') return '#9E9E9E'
  return '#9E9E9E'
}
const cols = computed(() => (vista.value === 'dia' ? 1 : 7))
const tituloMes = computed(() => {
  if (vista.value === 'dia') {
    return `${cursor.value.getDate()} de ${MESES[cursor.value.getMonth()]} ${cursor.value.getFullYear()}`
  }
  return `${MESES[cursor.value.getMonth()]} ${cursor.value.getFullYear()}`
})
const dias = computed(() => {
  const out = []
  if (vista.value === 'dia') {
    out.push(new Date(cursor.value))
    return out
  }
  if (vista.value === 'semana') {
    const base = new Date(cursor.value)
    const inicio = new Date(base)
    inicio.setDate(base.getDate() - base.getDay())
    for (let i = 0; i < 7; i++) out.push(sumarDias(inicio, i))
    return out
  }
  const y = cursor.value.getFullYear()
  const m = cursor.value.getMonth()
  const primero = new Date(y, m, 1)
  const inicioGrilla = sumarDias(primero, -primero.getDay())
  for (let i = 0; i < 42; i++) out.push(sumarDias(inicioGrilla, i))
  return out
})
const filas = computed(() => Math.ceil(dias.value.length / cols.value))
const diasCabecera = computed(() => {
  if (vista.value === 'dia') {
    const d = dias.value[0]
    return [{ key: 'h0', label: DIAS_CORTOS[d.getDay()], num: String(d.getDate()) }]
  }
  const mesActual = cursor.value.getMonth()
  const base = dias.value[0]
  return DIAS_CORTOS.map((l, i) => {
    const d = sumarDias(base, i)
    const num =
      d.getMonth() === mesActual
        ? String(d.getDate())
        : `${MESES_CORTOS[d.getMonth()]} ${d.getDate()}`
    return { key: `h${i}`, label: l, num }
  })
})
const celdas = computed(() =>
  dias.value.map((d) => ({
    fecha: d,
    dia: d.getDate(),
    enMes: d.getMonth() === cursor.value.getMonth(),
    esHoy: mismoDia(d, hoy)
  }))
)
const barras = computed(() => {
  const lista = dias.value
  const C = cols.value
  const resultado = []
  if (!lista.length) return resultado
  const primerDia = lista[0]
  const ordenadas = [...reservas.value].sort((a, b) =>
    String(soloFecha(a.entrada) || '').localeCompare(String(soloFecha(b.entrada) || ''))
  )
  const carriles = lista.map(() => new Set())
  for (const r of ordenadas) {
    const ini = soloFecha(r.entrada)
    const fin = soloFecha(r.salida)
    if (!ini || !fin || fin <= ini) continue
    const iniDia = new Date(ini + 'T00:00:00')
    const finDia = new Date(fin + 'T00:00:00')
    let cursorDia = iniDia < primerDia ? new Date(primerDia) : new Date(iniDia)
    let guardia = 0
    while (cursorDia < finDia && guardia < 90) {
      guardia++
      const idx = lista.findIndex((d) => mismoDia(d, cursorDia))
      if (idx === -1) {
        cursorDia = sumarDias(cursorDia, 1)
        continue
      }
      const fila = Math.floor(idx / C)
      const colInicio = (idx % C) + 1
      const ultimoIdxFila = Math.min(fila * C + (C - 1), lista.length - 1)
      const ultimoDeFila = lista[ultimoIdxFila]
      const terminaAqui = finDia <= sumarDias(ultimoDeFila, 1)
      let colFin
      if (terminaAqui) {
        const idxFin = lista.findIndex((d) => mismoDia(d, finDia))
        colFin = idxFin === -1 ? C + 1 : (idxFin % C) + 1
      } else {
        colFin = C + 1
      }
      if (colFin <= colInicio) colFin = colInicio + 1
      const desde = fila * C + (colInicio - 1)
      const hasta = desde + (colFin - colInicio)
      let carril = 0
      while (true) {
        let libre = true
        for (let i = desde; i < hasta; i++) {
          if (carriles[i]?.has(carril)) {
            libre = false
            break
          }
        }
        if (libre) break
        carril++
      }
      for (let i = desde; i < hasta; i++) {
        if (carriles[i]) carriles[i].add(carril)
      }
      resultado.push({
        id: `${r.id_reserva}-${fila}`,
        idReserva: r.id_reserva,
        cliente: r.cliente || '—',
        habitacion: r.habitacion || '—',
        estado: r.estado,
        entrada: ini,
        salida: fin,
        fila: fila + 1,
        carril,
        colInicio,
        colFin,
        continuaIzq: colInicio === 1 && cursorDia > iniDia,
        continuaDer: !terminaAqui
      })
      cursorDia = sumarDias(ultimoDeFila, 1)
    }
  }
  return resultado
})
function moverMes(delta) {
  const c = new Date(cursor.value)
  if (vista.value === 'dia') {
    c.setDate(c.getDate() + delta)
  } else if (vista.value === 'semana') {
    c.setDate(c.getDate() + delta * 7)
  } else {
    c.setMonth(c.getMonth() + delta)
  }
  cursor.value = c
}
function irHoy() {
  const n = new Date()
  cursor.value = new Date(n.getFullYear(), n.getMonth(), vista.value === 'dia' ? n.getDate() : 1)
}
function abrirNuevaEnFecha(d) {
  abrirNueva()
  form.value.fecha_inicio = ymd(d)
}
function verDetalle(item) {
  detalle.value = item
  dialogoDetalle.value = true
}
function verDetallePorId(id) {
  const r = reservas.value.find((x) => x.id_reserva === id)
  if (r) verDetalle(r)
}
function editarDesdeDetalle() {
  dialogoDetalle.value = false
  editar(detalle.value)
}
async function cargar() {
  cargando.value = true
  error.value = null
  try {
    const { data } = await listarReservaciones()
    const lista = Array.isArray(data) ? data : (data?.data ?? [])
    reservas.value = lista.map((r) => ({
      ...r,
      entrada: soloFecha(r.entrada ?? r.fecha_inicio),
      salida: soloFecha(r.salida ?? r.fecha_fin)
    }))
  } catch (e) {
    error.value = 'No se pudieron cargar las reservaciones.'
    reservas.value = []
  } finally {
    cargando.value = false
  }
}
async function cargarCatalogos() {
  try {
    const [c, h] = await Promise.all([listarClientes(), listarHabitaciones()])
    clientes.value = Array.isArray(c.data) ? c.data : (c.data?.data ?? [])
    habitaciones.value = Array.isArray(h.data) ? h.data : (h.data?.data ?? [])
  } catch (e) {
  }
}
function abrirNueva() {
  editando.value = null
  error.value = null
  form.value = { id_cliente: null, id_habitacion: null, fecha_inicio: '', fecha_fin: '', estado: 'Pendiente' }
  dialogo.value = true
}
function editar(item) {
  editando.value = item
  error.value = null
  form.value = {
    id_cliente: item.id_cliente,
    id_habitacion: item.id_habitacion,
    fecha_inicio: soloFecha(item.entrada),
    fecha_fin: soloFecha(item.salida),
    estado: item.estado || 'Pendiente'
  }
  dialogo.value = true
}
async function guardar() {
  if (!form.value.id_cliente || !form.value.id_habitacion) {
    error.value = 'Debes seleccionar un cliente y una habitación.'
    return
  }
  if (!form.value.fecha_inicio || !form.value.fecha_fin) {
    error.value = 'Debes indicar la fecha de entrada y de salida.'
    return
  }
  if (form.value.fecha_fin <= form.value.fecha_inicio) {
    error.value = 'La fecha de salida debe ser posterior a la de entrada.'
    return
  }
  guardando.value = true
  error.value = null
  try {
    if (editando.value) {
      await actualizarReservacion(editando.value.id_reserva, form.value)
    } else {
      await crearReservacion(form.value)
    }
    dialogo.value = false
    await cargar()
  } catch (e) {
    error.value = e.response?.data?.message || 'No se pudo guardar la reservación.'
  } finally {
    guardando.value = false
  }
}
onMounted(() => {
  cargar()
  cargarCatalogos()
})
</script>
<style scoped>
.cal-grid {
  display: grid;
  grid-template-columns: repeat(var(--cols, 7), 1fr);
}
.cal-head {
  border-left: 1px solid #e0e0e0;
  border-top: 1px solid #e0e0e0;
}
.cal-head-cell {
  padding: 4px 6px;
  text-align: center;
  background: #f7f7f7;
  border-right: 1px solid #e0e0e0;
  border-bottom: 1px solid #e0e0e0;
}
.cal-head-day {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.3px;
  color: #6b6b6b;
}
.cal-head-num {
  font-size: 11px;
  font-weight: 600;
  color: #2f2f2f;
  white-space: nowrap;
}
.cal-body {
  position: relative;
  display: grid;
  grid-template-columns: repeat(var(--cols, 7), 1fr);
  grid-template-rows: repeat(var(--filas), minmax(90px, auto));
}
.cal-fondo {
  grid-column: 1 / -1;
  grid-row: 1 / -1;
  grid-template-rows: repeat(var(--filas), minmax(90px, auto));
  border-left: 1px solid #e0e0e0;
}
.cal-cell {
  padding: 4px;
  border-right: 1px solid #e0e0e0;
  border-bottom: 1px solid #e0e0e0;
  cursor: pointer;
  transition: background 0.15s;
  overflow: hidden;
}
.cal-cell:hover {
  background: #fafafa;
}
.cal-out {
  background: #fbfbfb;
  color: #bdbdbd;
}
.cal-day-num {
  font-size: 11px;
  font-weight: 600;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.cal-today .cal-day-num {
  background: #0f3d2e;
  color: #f5efe0;
  border-radius: 50%;
}
.cal-barras {
  grid-column: 1 / -1;
  grid-row: 1 / -1;
  grid-template-rows: repeat(var(--filas), minmax(90px, auto));
  pointer-events: none;
}
.cal-bar {
  pointer-events: auto;
  position: relative;
  align-self: start;
  height: 16px;
  margin-left: 2px;
  margin-right: 2px;
  padding: 0 5px;
  font-size: 10px;
  line-height: 16px;
  color: #fff;
  border-radius: 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
  z-index: 2;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.16);
  transition: filter 0.15s;
}
.cal-bar:hover {
  filter: brightness(1.12);
}
.bar-izq {
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  margin-left: 0;
}
.bar-der {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
  margin-right: 0;
}
.cal-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}
</style>
