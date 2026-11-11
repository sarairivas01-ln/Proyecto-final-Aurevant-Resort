<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h1 class="text-h5 font-weight-bold">Clientes</h1>
        <p class="text-body-2 text-medium-emphasis">Registro y seguimiento de huéspedes</p>
      </div>
      <v-btn color="#0F3D2E" prepend-icon="mdi-account-plus" @click="abrirNuevo">
        Registrar cliente
      </v-btn>
    </div>
    <v-alert v-if="error" type="error" variant="tonal" class="mb-4">{{ error }}</v-alert>
    <v-card class="pa-4">
      <v-text-field v-model="busqueda" prepend-inner-icon="mdi-magnify"
        label="Buscar por nombre o documento" variant="outlined" density="comfortable"
        hide-details clearable class="mb-4" />
      <v-data-table
        item-value="id_cliente"
        :headers="headers"
        :items="filtrados"
        :loading="cargando"
        loading-text="Cargando clientes..."
        no-data-text="No hay clientes registrados."
        density="comfortable"
      >
        <template #item.acciones="{ item }">
          <v-btn size="small" variant="outlined" color="#0F3D2E" rounded="lg"
            prepend-icon="mdi-pencil" @click="editar(item)">Editar</v-btn>
        </template>
      </v-data-table>
    </v-card>
    <v-dialog v-model="dialogo" max-width="560">
      <v-card class="pa-4">
        <h3 class="text-h6 mb-4">{{ editando ? 'Editar cliente' : 'Registrar cliente' }}</h3>
        <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-3">
          {{ error }}
        </v-alert>
        <v-text-field v-model="form.nombre" label="Nombre completo" variant="outlined" density="comfortable" />
        <v-text-field v-model="form.telefono" label="Teléfono" variant="outlined" density="comfortable" />
        <v-text-field v-model="form.email" label="Correo" type="email" variant="outlined" density="comfortable" />
        <v-text-field v-model="form.DUI" label="DUI" variant="outlined" density="comfortable" />
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
import { listarClientes, crearCliente, actualizarCliente } from '@/services/clientesService'
const clientes = ref([])
const cargando = ref(false)
const guardando = ref(false)
const error = ref(null)
const busqueda = ref('')
const dialogo = ref(false)
const editando = ref(null)
const form = ref({})
const headers = [
  { title: 'Nombre', key: 'nombre' },
  { title: 'Teléfono', key: 'telefono' },
  { title: 'Correo', key: 'email' },
  { title: 'DUI', key: 'DUI' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const filtrados = computed(() => {
  const q = busqueda.value?.toLowerCase().trim()
  if (!q) return clientes.value
  return clientes.value.filter((c) =>
    String(c.nombre || '').toLowerCase().includes(q) ||
    String(c.DUI || '').toLowerCase().includes(q)
  )
})
async function cargar() {
  cargando.value = true
  error.value = null
  try {
    const { data } = await listarClientes()
    clientes.value = data
  } catch (e) {
    error.value = 'No se pudieron cargar los clientes.'
    clientes.value = []
  } finally {
    cargando.value = false
  }
}
function abrirNuevo() {
  editando.value = null
  error.value = null
  form.value = { nombre: '', telefono: '', email: '', DUI: '' }
  dialogo.value = true
}
function editar(item) {
  editando.value = item
  error.value = null
  form.value = {
    nombre: item.nombre,
    telefono: item.telefono,
    email: item.email,
    DUI: item.DUI
  }
  dialogo.value = true
}
async function guardar() {
  if (!form.value.nombre) {
    error.value = 'El nombre es obligatorio.'
    return
  }
  guardando.value = true
  error.value = null
  try {
    if (editando.value) {
      await actualizarCliente(editando.value.id_cliente, form.value)
    } else {
      await crearCliente(form.value)
    }
    dialogo.value = false
    await cargar()
  } catch (e) {
    const errores = e.response?.data?.errors
    error.value = errores
      ? Object.values(errores).flat().join(' ')
      : e.response?.data?.message || 'No se pudo guardar el cliente.'
  } finally {
    guardando.value = false
  }
}
onMounted(cargar)
</script>
