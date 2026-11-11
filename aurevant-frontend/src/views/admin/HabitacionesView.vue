<template>
  <div class="habitaciones-view">
    <div class="d-flex align-center justify-space-between mb-6">
      <div>
        <h1 class="titulo">Habitaciones</h1>
        <p class="subtitulo">Gestiona las habitaciones de AUREVANT Resort.</p>
      </div>
      <v-btn color="#0F3D2E" dark @click="abrirDialogoNueva()">
        <v-icon left>mdi-plus</v-icon> Nueva habitación
      </v-btn>
    </div>
    <v-text-field
      v-model="busqueda"
      label="Buscar por número o tipo"
      prepend-inner-icon="mdi-magnify"
      variant="outlined"
      density="compact"
      class="mb-4"
      clearable
    ></v-text-field>
    <v-row v-if="habitacionesFiltradas.length">
      <v-col
        v-for="h in habitacionesFiltradas"
        :key="h.id_habitacion"
        cols="12"
        sm="6"
        md="4"
        lg="3"
      >
        <v-card class="habitacion-card" elevation="2" :class="{ inactiva: !h.activa }">
          <v-img
            :src="urlImagen(h.img)"
            height="160"
            cover
            class="align-end"
            @click="abrirPreview = h"
          >
            <v-chip :color="colorHabitacion(h.estado)" dark size="small" class="ma-2">
              {{ h.estado }}
            </v-chip>
          </v-img>
          <v-card-title class="py-2">
            {{ h.tipo }} · Hab. {{ h.numero }}
          </v-card-title>
          <v-card-text class="pt-0">
            <div class="text-h6 gold">${{ h.precio_noche }} / noche</div>
            <div class="mt-1 meta">
              <v-icon size="small">mdi-account-group</v-icon> {{ h.capacidad }} personas
              <span class="mx-2">·</span>
              <v-icon size="small">mdi-image-filter-hdr</v-icon> {{ h.vista }}
            </div>
            <div class="mt-1 meta">
              <v-icon size="small">mdi-balcony</v-icon>
              {{ h.balcon ? 'Con balcón' : 'Sin balcón' }}
            </div>
            <p class="descripcion mt-2">{{ h.descripcion }}</p>
          </v-card-text>
          <v-card-actions>
            <v-btn size="small" variant="text" color="#0F3D2E" @click="editarHabitacion(h)">
              <v-icon left size="small">mdi-pencil</v-icon> Editar
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn
              size="small"
              variant="text"
              :color="h.activa ? 'error' : 'success'"
              @click="desactivarHabitacion(h)"
            >
              <v-icon left size="small">{{ h.activa ? 'mdi-power' : 'mdi-power-off' }}</v-icon>
              {{ h.activa ? 'Desactivar' : 'Activar' }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <v-alert v-else type="info" variant="outlined" class="mt-4">
      No hay habitaciones que coincidan con la búsqueda.
    </v-alert>
    <v-dialog v-model="dialogo" max-width="600">
      <v-card>
        <v-card-title class="headline">
          {{ editando ? 'Editar habitación' : 'Nueva habitación' }}
        </v-card-title>
        <v-card-text>
          <v-form>
            <v-row>
              <v-col cols="6">
                <v-text-field v-model="form.numero" label="Número" variant="outlined" density="compact" required></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-select
                  v-model="form.tipo"
                  :items="['Suite', 'Deluxe', 'Estándar', 'Familiar']"
                  label="Tipo"
                  variant="outlined"
                  density="compact"
                  required
                ></v-select>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model.number="form.precio_noche"
                  label="Precio por noche ($)"
                  type="number"
                  variant="outlined"
                  density="compact"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model.number="form.capacidad"
                  label="Capacidad"
                  type="number"
                  variant="outlined"
                  density="compact"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-select
                  v-model="form.vista"
                  :items="['Montaña', 'Bosque', 'Jardín']"
                  label="Vista"
                  variant="outlined"
                  density="compact"
                  required
                ></v-select>
              </v-col>
              <v-col cols="6">
                <v-switch v-model="form.balcon" label="Balcón" color="#0F3D2E"></v-switch>
              </v-col>
              <v-col cols="12">
                <v-select
                  v-model="form.estado"
                  :items="['Disponible', 'Ocupada', 'Mantenimiento']"
                  label="Estado"
                  variant="outlined"
                  density="compact"
                ></v-select>
              </v-col>
              <v-col cols="12">
                <v-textarea
                  v-model="form.descripcion"
                  label="Descripción"
                  variant="outlined"
                  density="compact"
                  rows="3"
                ></v-textarea>
              </v-col>
            </v-row>
<div class="mt-2">
  <p class="mb-1">Imagen de la habitación</p>
  <v-img
    v-if="preview || form.img"
    :src="preview || urlImagen(form.img)"
    height="120"
    contain
    class="mb-2"
  ></v-img>
  <v-file-input
    v-model="archivo"
    label="Subir imagen"
    accept="image/*"
    variant="outlined"
    density="compact"
    prepend-icon=""
    prepend-inner-icon="mdi-camera"
    @update:modelValue="previsualizarArchivo"
  ></v-file-input>
</div>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="dialogo = false">Cancelar</v-btn>
          <v-btn color="#0F3D2E" dark :disabled="!formValido" @click="guardar">
            Guardar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="abrirPreview" max-width="700">
      <v-img
        v-if="abrirPreview"
        :src="urlImagen(abrirPreview.img)"
        contain
        max-height="500"
      ></v-img>
    </v-dialog>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
import api from '@/services/api'
const busqueda = ref('')
const dialogo = ref(false)
const editando = ref(false)
const abrirPreview = ref(false)
const archivo = ref(null)
const preview = ref('')          
const habitaciones = ref([])
const form = ref({
  numero: '',
  tipo: null,
  capacidad: 1,
  precio_noche: null,
  descripcion: '',
  vista: null,
  balcon: false,
  estado: 'Disponible',
  activa: true,
  img: ''
})
async function cargarHabitaciones() {
  try {
    const { data } = await api.get('/habitaciones')
    habitaciones.value = data
  } catch (e) {
    console.error('Error al cargar habitaciones', e)
  }
}
cargarHabitaciones()
const habitacionesFiltradas = computed(() => {
  const q = busqueda.value.trim().toLowerCase()
  if (!q) return habitaciones.value
  return habitaciones.value.filter(
    h =>
      String(h.numero).toLowerCase().includes(q) ||
      String(h.tipo).toLowerCase().includes(q)
  )
})
const formValido = computed(
  () =>
    !!form.value.numero?.trim() &&
    !!form.value.tipo &&
    !!form.value.vista &&
    !!form.value.estado &&
    Number(form.value.precio_noche) > 0 &&
    Number(form.value.capacidad) >= 1
)
const urlImagen = (img) => {
  if (!img) return 'https://via.placeholder.com/400x200?text=Sin+imagen'
  if (img.startsWith('http') || img.startsWith('blob:')) return img
  return `http://127.0.0.1:8000/storage/${img}`
}
function abrirDialogoNueva() {
  editando.value = false
  form.value = {
    numero: '',
    tipo: null,
    capacidad: 1,
    precio_noche: null,
    descripcion: '',
    vista: null,
    balcon: false,
    estado: 'Disponible',
    activa: true,
    img: ''
  }
  archivo.value = null
  preview.value = ''
  dialogo.value = true
}
function editarHabitacion(h) {
  editando.value = true
  form.value = {
    id_habitacion: h.id_habitacion,
    numero: h.numero,
    tipo: h.tipo,
    capacidad: Number(h.capacidad),
    precio_noche: Number(h.precio_noche),
    descripcion: h.descripcion ?? '',
    vista: h.vista,
    balcon: !!h.balcon,
    estado: h.estado,
    activa: !!h.activa,
    img: h.img ?? ''
  }
  archivo.value = null
  preview.value = ''
  dialogo.value = true
}
function previsualizarArchivo(file) {
  const f = Array.isArray(file) ? file[0] : file
  preview.value = f instanceof File ? URL.createObjectURL(f) : ''
}
async function guardar() {
  if (!formValido.value) return
  try {
    const fd = new FormData()
    fd.append('numero', String(form.value.numero).trim())
    fd.append('tipo', form.value.tipo)
    fd.append('capacidad', String(Number(form.value.capacidad)))
    fd.append('precio_noche', String(Number(form.value.precio_noche)))
    fd.append('descripcion', form.value.descripcion ?? '')
    fd.append('vista', form.value.vista)
    fd.append('balcon', form.value.balcon ? '1' : '0')
    fd.append('estado', form.value.estado)
    fd.append('activa', form.value.activa ? '1' : '0')
    const f = Array.isArray(archivo.value) ? archivo.value[0] : archivo.value
    if (f instanceof File) fd.append('img', f)
    if (editando.value) {
      fd.append('_method', 'PUT')
      const { data } = await api.post(`/habitaciones/${form.value.id_habitacion}`, fd, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
      const i = habitaciones.value.findIndex(x => x.id_habitacion === data.id_habitacion)
      if (i !== -1) habitaciones.value[i] = data
    } else {
      const { data } = await api.post('/habitaciones', fd, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
      habitaciones.value.push(data)
    }
    dialogo.value = false
  } catch (e) {
    if (e.response?.status === 422) {
      console.table(e.response.data.errors)
    }
    console.error('Error al guardar', e.response?.data ?? e)
  }
}
async function desactivarHabitacion(h) {
  try {
    const { data } = await api.patch(`/habitaciones/${h.id_habitacion}/toggle`)
    const i = habitaciones.value.findIndex(x => x.id_habitacion === data.id_habitacion)
    if (i !== -1) habitaciones.value[i] = data
  } catch (e) {
    console.error('Error al cambiar estado', e)
  }
}
function colorHabitacion(e) {
  if (e === 'Disponible') return 'success'
  if (e === 'Ocupada') return 'warning'
  if (e === 'Mantenimiento') return 'grey'
  return 'error'
}
</script>
