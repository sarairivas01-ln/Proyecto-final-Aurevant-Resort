<template>
  <div>
    <div class="d-flex justify-space-between align-center mb-6">
      <div>
        <h2 class="page-title">Platillos</h2>
        <p class="page-sub">Platillos y bebidas del restaurante.</p>
      </div>
      <v-btn color="#0F3D2E" variant="flat" rounded="lg" prepend-icon="mdi-plus" @click="abrirNuevo">
        Nuevo platillo
      </v-btn>
    </div>
    <v-alert v-if="error" type="error" variant="tonal" class="mb-4" closable @click:close="error = ''">
      {{ error }}
    </v-alert>
    <v-card class="panel" elevation="0">
      <v-data-table
        :headers="headers"
        :items="platillos"
        :loading="cargando"
        loading-text="Cargando platillos..."
        density="comfortable"
        class="tabla-aurevant"
      >
        <template #item.img="{ item }">
          <v-avatar size="44" rounded="lg" class="my-1">
            <v-img :src="urlImagen(item.img)" cover />
          </v-avatar>
        </template>
        <template #item.precio="{ item }">
          ${{ Number(item.precio).toFixed(2) }}
        </template>
        <template #item.tipo="{ item }">
          <v-chip size="small" variant="tonal" color="#0F3D2E">
            {{ item.tipo === 'bebida' ? 'Bebida' : 'Platillo' }}
          </v-chip>
        </template>
        <template #item.activo="{ item }">
          <v-chip :color="item.activo ? 'success' : 'grey'" size="small" variant="flat">
            {{ item.activo ? 'Activo' : 'Desactivado' }}
          </v-chip>
        </template>
        <template #item.acciones="{ item }">
          <v-menu location="bottom end">
            <template #activator="{ props }">
              <v-btn icon="mdi-dots-horizontal" variant="text" size="small" v-bind="props" />
            </template>
            <v-list density="compact">
              <v-list-item prepend-icon="mdi-pencil-outline" @click="editar(item)">Editar</v-list-item>
              <v-list-item
                :prepend-icon="item.activo ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                @click="alternarActivo(item)"
              >
                {{ item.activo ? 'Desactivar' : 'Activar' }}
              </v-list-item>
              <v-list-item prepend-icon="mdi-delete-outline" @click="confirmarEliminar(item)">Eliminar</v-list-item>
            </v-list>
          </v-menu>
        </template>
      </v-data-table>
    </v-card>
    <v-dialog v-model="dialog" max-width="560">
      <v-card class="pa-4" elevation="0">
        <v-card-title class="text-h6">
          {{ editando ? 'Editar platillo' : 'Nuevo platillo' }}
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="form.nombre" label="Nombre" variant="outlined" density="compact" class="mb-2" />
          <v-row dense>
            <v-col cols="12" sm="6">
              <v-select
                v-model="form.categoria"
                :items="categorias"
                label="Categoría"
                variant="outlined"
                density="compact"
              />
            </v-col>
            <v-col cols="12" sm="6">
              <v-select
                v-model="form.tipo"
                :items="tipos"
                item-title="label"
                item-value="value"
                label="Tipo"
                variant="outlined"
                density="compact"
              />
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                v-model.number="form.precio"
                label="Precio"
                type="number"
                prefix="$"
                variant="outlined"
                density="compact"
              />
            </v-col>
            <v-col cols="12" sm="6" class="d-flex align-center">
              <v-switch
                v-model="form.activo"
                :label="form.activo ? 'Activo' : 'Desactivado'"
                :color="form.activo ? '#0F3D2E' : 'grey'"
                density="compact"
                hide-details
                inset
              />
            </v-col>
          </v-row>
          <v-textarea v-model="form.descripcion" label="Descripción" rows="2" variant="outlined" density="compact" class="mb-2" />
          <v-textarea v-model="form.ingredientes" label="Ingredientes" rows="2" variant="outlined" density="compact" class="mb-2" />
          <v-file-input
            v-model="archivo"
            label="Imagen del platillo (PNG o JPG)"
            accept="image/png, image/jpeg, image/webp"
            prepend-icon=""
            prepend-inner-icon="mdi-camera-outline"
            variant="outlined"
            density="compact"
            show-size
            :rules="reglasImagen"
            @update:model-value="previsualizar"
          />
          <div v-if="preview" class="preview-box">
            <v-img :src="preview" height="150" cover class="rounded-lg" />
            <v-btn
              size="x-small"
              variant="text"
              color="error"
              class="mt-1"
              prepend-icon="mdi-close"
              @click="quitarImagen"
            >Quitar imagen</v-btn>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn variant="text" @click="cerrarDialog">Cancelar</v-btn>
          <v-btn color="#0F3D2E" variant="flat" rounded="lg" :loading="guardando" @click="guardar">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Confirmar eliminar -->
    <v-dialog v-model="dialogEliminar" max-width="400">
      <v-card class="pa-4" elevation="0">
        <v-card-title class="text-h6">¿Eliminar platillo?</v-card-title>
        <v-card-text v-if="aEliminar">
          Se eliminará <strong>{{ aEliminar.nombre }}</strong> de la base de datos.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn variant="text" @click="dialogEliminar = false">Cancelar</v-btn>
          <v-btn color="error" variant="flat" rounded="lg" :loading="eliminando" @click="eliminar">Eliminar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import {
  listarPlatillos, crearPlatillo, actualizarPlatillo, eliminarPlatillo
} from '@/services/platillosService'
const API_BASE = 'http://localhost:8000'
const headers = [
  { title: 'Imagen', key: 'img', sortable: false },
  { title: 'Nombre', key: 'nombre' },
  { title: 'Categoría', key: 'categoria' },
  { title: 'Tipo', key: 'tipo' },
  { title: 'Precio', key: 'precio' },
  { title: 'Estado', key: 'activo' },
  { title: 'Acciones', key: 'acciones', sortable: false }
]
const categorias = [
  'Entradas',
  'Sopas y caldos',
  'Ensaladas',
  'Carnes',
  'Mariscos',
  'Aves',
  'Platos fuertes',
  'Guarniciones',
  'Postres',
  'Bebidas',
  'Cocteles'
]
const tipos = [
  { label: 'Platillo', value: 'platillo' },
  { label: 'Bebida', value: 'bebida' }
]
const platillos = ref([])
const cargando = ref(false)
const guardando = ref(false)
const eliminando = ref(false)
const error = ref('')
const dialog = ref(false)
const editando = ref(false)
const idEditando = ref(null)
const dialogEliminar = ref(false)
const aEliminar = ref(null)
const archivo = ref(null)
const preview = ref('')
const reglasImagen = [
  v => !v || !v.length || v[0].size < 2 * 1024 * 1024 || 'La imagen debe pesar menos de 2 MB',
  v => !v || !v.length || ['image/png', 'image/jpeg', 'image/webp'].includes(v[0].type) || 'Solo PNG, JPG o WEBP'
]
const form = reactive({
  nombre: '',
  categoria: 'Platos fuertes',
  tipo: 'platillo',
  precio: 0,
  descripcion: '',
  ingredientes: '',
  activo: true
})
function urlImagen(ruta) {                                    
  if (!ruta) return ''                                       
  if (ruta.startsWith('http') || ruta.startsWith('blob:')) return ruta
  if (ruta.startsWith('/storage/')) return `${API_BASE}${ruta}`
  return `${API_BASE}/storage/${ruta}`                       
}
function previsualizar(files) {
  const f = Array.isArray(files) ? files[0] : files
  if (!f) return
  if (preview.value.startsWith('blob:')) URL.revokeObjectURL(preview.value)  
  preview.value = URL.createObjectURL(f)
}
function quitarImagen() {
  if (preview.value.startsWith('blob:')) URL.revokeObjectURL(preview.value)  
  archivo.value = null
  preview.value = ''
}
function cerrarDialog() {                                   
  dialog.value = false
  setTimeout(() => {                                         
    archivo.value = null
    preview.value = ''
  }, 300)
}
async function cargar() {
  cargando.value = true
  error.value = ''
  try {
    const { data } = await listarPlatillos()
    platillos.value = data
  } catch (e) {
    error.value = 'No se pudieron cargar los platillos. Revisa que Laravel esté corriendo.'
  } finally {
    cargando.value = false
  }
}
function limpiarForm() {
  Object.assign(form, {
    nombre: '',
    categoria: 'Platos fuertes',
    tipo: 'platillo',
    precio: 0,
    descripcion: '',
    ingredientes: '',
    activo: true
  })
  archivo.value = null
  preview.value = ''
}
function abrirNuevo() {
  limpiarForm()
  editando.value = false
  idEditando.value = null
  dialog.value = true
}
function editar(item) {
  Object.assign(form, {
    nombre: item.nombre,
    categoria: item.categoria,
    tipo: item.tipo,
    precio: Number(item.precio),
    descripcion: item.descripcion || '',
    ingredientes: item.ingredientes || '',
    activo: !!item.activo
  })
  archivo.value = null
  preview.value = item.img ? urlImagen(item.img) : ''
  editando.value = true
  idEditando.value = item.id_platillo
  dialog.value = true
}
async function guardar() {
  if (!form.nombre || Number(form.precio) <= 0) {
    error.value = 'El nombre es obligatorio y el precio debe ser mayor a 0.'
    return
  }
  guardando.value = true
  error.value = ''
  try {
    const f = Array.isArray(archivo.value) ? archivo.value[0] : archivo.value
    const payload = { ...form, img: f || null }
    if (editando.value) {
      const { data } = await actualizarPlatillo(idEditando.value, payload)
      const i = platillos.value.findIndex(p => p.id_platillo === idEditando.value)
      if (i !== -1) platillos.value[i] = data
    } else {
      const { data } = await crearPlatillo(payload)
      platillos.value.unshift(data)
    }
    cerrarDialog()                                            // ←
  } catch (e) {
    error.value = 'No se pudo guardar. Revisa los datos enviados.'
  } finally {
    guardando.value = false
  }
}
async function alternarActivo(item) {
  try {
    const { data } = await actualizarPlatillo(item.id_platillo, {
      nombre: item.nombre,
      descripcion: item.descripcion,
      precio: Number(item.precio),
      categoria: item.categoria,
      tipo: item.tipo,
      ingredientes: item.ingredientes,
      activo: !item.activo
    })
    const i = platillos.value.findIndex(p => p.id_platillo === item.id_platillo)
    if (i !== -1) platillos.value[i] = data
  } catch (e) {
    error.value = 'No se pudo cambiar el estado del platillo.'
  }
}
function confirmarEliminar(item) {
  aEliminar.value = item
  dialogEliminar.value = true
}
async function eliminar() {
  eliminando.value = true
  try {
    await eliminarPlatillo(aEliminar.value.id_platillo)
    platillos.value = platillos.value.filter(
      p => p.id_platillo !== aEliminar.value.id_platillo
    )
    dialogEliminar.value = false
    setTimeout(() => { aEliminar.value = null }, 300)         // ←
  } catch (e) {
    error.value = 'No se pudo eliminar el platillo.'
  } finally {
    eliminando.value = false
  }
}
onMounted(cargar)
</script>
<style scoped>
.page-title { font-family: 'Cormorant Garamond', serif; font-size: 26px; color: #1A1A1A; }
.page-sub { font-size: 13px; color: #6B6B6B; }
.panel {
  background: #FFFFFF;
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  padding: 16px;
}
.preview-box {
  border: 1px dashed rgba(212, 180, 131, 0.7);
  border-radius: 10px;
  padding: 8px;
  margin-top: 4px;
}
</style>
