<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">Clientes</h1>
        <p class="text-body-2 text-medium-emphasis">
          Huéspedes registrados desde recepción y desde la app móvil.
        </p>
      </div>
      <div class="d-flex ga-2">
        <v-btn variant="outlined" size="small" prepend-icon="mdi-refresh" @click="cargar">
          Actualizar
        </v-btn>
        <v-btn color="#0F3D2E" size="small" prepend-icon="mdi-plus" @click="abrirCrear">
          Nuevo cliente
        </v-btn>
      </div>
    </div>
    <v-alert v-if="error" type="error" density="compact" variant="tonal" class="mb-4">
      {{ error }}
    </v-alert>
    <v-row class="mb-2">
      <v-col cols="12" sm="6" md="3">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Clientes registrados</div>
          <div class="text-h4 font-weight-bold">{{ clientes.length }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="3">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Registrados hoy</div>
          <div class="text-h4 font-weight-bold">{{ registradosHoy }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="3">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Sin DUI</div>
          <div class="text-h4 font-weight-bold">{{ sinDui }}</div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="6" md="3">
        <v-card class="pa-4 kpi">
          <div class="text-caption text-medium-emphasis">Con correo</div>
          <div class="text-h4 font-weight-bold">{{ conCorreo }}</div>
        </v-card>
      </v-col>
    </v-row>
    <v-card class="pa-4">
      <div class="d-flex justify-space-between align-center mb-3">
        <h3 class="text-subtitle-1 font-weight-bold">Listado de clientes</h3>
        <v-text-field
          v-model="busqueda"
          label="Buscar por nombre, teléfono o DUI"
          prepend-inner-icon="mdi-magnify"
          variant="outlined"
          density="compact"
          hide-details
          style="max-width: 320px"
        />
      </div>
      <v-data-table
        :headers="headers"
        :items="filtrados"
        :items-per-page="10"
        density="compact"
        item-value="id_cliente"
        no-data-text="No hay clientes registrados."
      >
        <template #item.nombre="{ item }">
          <div>
            <p class="mb-0 font-weight-medium">{{ item.nombre }}</p>
            <p class="text-caption text-medium-emphasis mb-0">{{ item.email || '—' }}</p>
          </div>
        </template>
        <template #item.DUI="{ item }">
          <span :class="item.DUI ? '' : 'text-medium-emphasis'">
            {{ item.DUI || 'Sin DUI' }}
          </span>
        </template>
        <template #item.acciones="{ item }">
          <div class="d-flex ga-1 justify-end">
            <v-btn icon="mdi-pencil" size="small" variant="text" @click="abrirEditar(item)" />
            <v-btn
              v-if="esAdmin"
              icon="mdi-delete"
              size="small"
              variant="text"
              color="#C0392B"
              @click="pedirEliminar(item)"
            />
          </div>
        </template>
      </v-data-table>
    </v-card>
    <v-dialog v-model="dialogo" max-width="520">
      <v-card class="pa-6">
        <h3 class="text-h6 font-weight-bold mb-4">
          {{ editando ? 'Editar cliente' : 'Nuevo cliente' }}
        </h3>
        <v-alert v-if="errorForm" type="error" density="compact" variant="tonal" class="mb-4">
          {{ errorForm }}
        </v-alert>
        <v-text-field
          v-model="form.nombre"
          label="Nombre completo"
          variant="outlined"
          density="comfortable"
          class="mb-3"
        />
        <v-text-field
          v-model="form.telefono"
          label="Teléfono"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-phone"
          class="mb-3"
        />
        <v-text-field
          v-model="form.email"
          label="Correo"
          type="email"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-email"
          class="mb-3"
        />
        <v-text-field
          v-model="form.DUI"
          label="DUI (opcional)"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-card-account-details-outline"
          hint="Puedes dejarlo vacío si el cliente no lo proporciona"
          persistent-hint
          class="mb-4"
        />
        <div class="d-flex justify-end ga-2">
          <v-btn variant="text" @click="dialogo = false">Cancelar</v-btn>
          <v-btn color="#0F3D2E" :loading="guardando" @click="guardar">
            {{ editando ? 'Guardar cambios' : 'Registrar cliente' }}
          </v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogoEliminar" max-width="420">
      <v-card class="pa-6">
        <h3 class="text-h6 font-weight-bold mb-2">Eliminar cliente</h3>
        <p class="text-body-2 mb-4">
          ¿Seguro que quieres eliminar a <strong>{{ aEliminar?.nombre }}</strong>?
          También se borrarán sus reservas.
        </p>
        <div class="d-flex justify-end ga-2">
          <v-btn variant="text" @click="dialogoEliminar = false">Cancelar</v-btn>
          <v-btn color="#C0392B" :loading="eliminando" @click="eliminar">Eliminar</v-btn>
        </div>
      </v-card>
    </v-dialog>
    <v-snackbar v-model="aviso" :timeout="3000" color="#0F3D2E">
      {{ avisoTexto }}
    </v-snackbar>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '@/services/api'
import { useRoute, useRouter } from 'vue-router'
const route = useRoute()
const router = useRouter()
const clientes = ref([])
const busqueda = ref('')
const error = ref(null)
const dialogo = ref(false)
const editando = ref(false)
const guardando = ref(false)
const errorForm = ref(null)
const dialogoEliminar = ref(false)
const aEliminar = ref(null)
const eliminando = ref(false)
const aviso = ref(false)
const avisoTexto = ref('')
const headers = [
  { title: 'Cliente', key: 'nombre' },
  { title: 'Teléfono', key: 'telefono' },
  { title: 'DUI', key: 'DUI' },
  { title: 'Acciones', key: 'acciones', sortable: false, align: 'end' }
]
const form = ref({
  id_cliente: null,
  nombre: '',
  telefono: '',
  email: '',
  DUI: ''
})
const esAdmin = computed(() => {
  try {
    const u = JSON.parse(localStorage.getItem('usuario') || '{}')
    return (u.rol || '').toLowerCase() === 'admin'
  } catch {
    return false
  }
})
const registradosHoy = computed(() => {
  const hoy = new Date().toDateString()
  return clientes.value.filter(c =>
    c.created_at && new Date(c.created_at).toDateString() === hoy
  ).length
})
const sinDui = computed(() => clientes.value.filter(c => !c.DUI).length)
const conCorreo = computed(() => clientes.value.filter(c => !!c.email).length)
const filtrados = computed(() => {
  const q = busqueda.value.trim().toLowerCase()
  if (!q) return clientes.value
  return clientes.value.filter(c =>
    [c.nombre, c.telefono, c.DUI, c.email]
      .filter(Boolean)
      .some(v => String(v).toLowerCase().includes(q))
  )
})
function mostrarAviso(texto) {
  avisoTexto.value = texto
  aviso.value = true
}
async function cargar() {
  error.value = null
  try {
    const { data } = await api.get('/clientes')
    clientes.value = data
  } catch (e) {
    error.value = 'No se pudieron cargar los clientes.'
  }
}
function abrirCrear() {
  errorForm.value = null
  editando.value = false
  form.value = { id_cliente: null, nombre: '', telefono: '', email: '', DUI: '' }
  dialogo.value = true
}
function abrirEditar(cliente) {
  errorForm.value = null
  editando.value = true
  form.value = {
    id_cliente: cliente.id_cliente,
    nombre: cliente.nombre || '',
    telefono: cliente.telefono || '',
    email: cliente.email || '',
    DUI: cliente.DUI || ''
  }
  dialogo.value = true
}
async function guardar() {
  errorForm.value = null
  if (!form.value.nombre || !form.value.telefono) {
    errorForm.value = 'El nombre y el teléfono son obligatorios.'
    return
  }
  guardando.value = true
  try {
    const payload = {
      nombre: form.value.nombre,
      telefono: form.value.telefono,
      email: form.value.email || null,
      DUI: form.value.DUI || null
    }
    if (editando.value) {
      await api.put(`/clientes/${form.value.id_cliente}`, payload)
      mostrarAviso('Cliente actualizado.')
    } else {
      await api.post('/clientes', payload)
      mostrarAviso('Cliente registrado.')
    }
    dialogo.value = false
    await cargar()
  } catch (e) {
    errorForm.value = e.response?.data?.message || 'No se pudo guardar el cliente.'
  } finally {
    guardando.value = false
  }
}
function pedirEliminar(cliente) {
  aEliminar.value = cliente
  dialogoEliminar.value = true
}
async function eliminar() {
  eliminando.value = true
  try {
    await api.delete(`/clientes/${aEliminar.value.id_cliente}`)
    dialogoEliminar.value = false
    mostrarAviso('Cliente eliminado.')
    await cargar()
  } catch (e) {
    error.value = 'No se pudo eliminar el cliente.'
  } finally {
    eliminando.value = false
  }
}
async function abrirDesdeQuery() {
  const id = route.query.id
  if (!id) return
  const cliente = clientes.value.find(c => String(c.id_cliente) === String(id))
  if (cliente) abrirEditar(cliente)
  router.replace({ path: route.path })
}
onMounted(async () => {
  await cargar()
  abrirDesdeQuery()
})
</script>
<style scoped>
.kpi {
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  background: #FFFFFF;
}
</style>
