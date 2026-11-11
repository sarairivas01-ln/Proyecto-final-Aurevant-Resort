<template>
  <v-app>
    <v-main class="d-flex align-center justify-center" style="background:#F7EFE3">
      <v-card class="pa-8" width="380" elevation="4" rounded="lg">
        <h1 class="text-h5 font-weight-bold text-center mb-1" style="color:#0F3D2E">
          AUREVANT
        </h1>
        <p class="text-caption text-center mb-6" style="color:#D4B483">
          El lujo encuentra su altura
        </p>
        <v-text-field
          v-model="email"
          label="Correo"
          prepend-inner-icon="mdi-email-outline"
          variant="outlined"
          density="comfortable"
          color="#0F3D2E"
          class="mb-2"
        />
        <v-text-field
          v-model="password"
          label="Contraseña"
          type="password"
          prepend-inner-icon="mdi-lock-outline"
          variant="outlined"
          density="comfortable"
          color="#0F3D2E"
          class="mb-4"
          @keyup.enter="entrar"
        />
        <v-select
          v-model="rol"
          :items="roles"
          item-title="text"
          item-value="value"
          label="Rol"
          variant="outlined"
          density="comfortable"
          color="#0F3D2E"
          class="mb-4"
        />
        <v-alert
          v-if="alerta.texto"
          :type="alerta.tipo"
          variant="tonal"
          density="compact"
          class="mb-4"
          closable
          @click:close="alerta.texto = ''"
        >
          {{ alerta.texto }}
        </v-alert>
        <v-btn
          block
          size="large"
          :loading="cargando"
          style="background:#0F3D2E; color:#F7EFE3"
          @click="entrar"
        >
          Iniciar sesión
        </v-btn>
      </v-card>
    </v-main>
  </v-app>
</template>
<script setup>
import { ref, reactive } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import axios from 'axios'
const store = useStore()
const router = useRouter()
const email = ref('admin@aurevant.com')
const password = ref('12345678')
const rol = ref('admin')
const cargando = ref(false)
const alerta = reactive({ texto: '', tipo: 'warning' })
const roles = [
  { text: 'Administrador', value: 'admin' },
  { text: 'Recepcionista', value: 'recepcion' }
]
function mostrarAlerta(texto, tipo = 'warning') {
  alerta.texto = texto
  alerta.tipo = tipo
}
async function entrar() {
  alerta.texto = ''
  cargando.value = true
  try {
    const data = await store.dispatch('auth/login', {
      email: email.value,
      password: password.value,
    })
    const rolReal = data.user.rol
    if (rolReal !== rol.value) {
      mostrarAlerta('Revisa las credenciales o el rol seleccionado.', 'error')
      store.dispatch('auth/logout') 
      return
    }
    axios.defaults.headers.common.Authorization = `Bearer ${data.token}`
    router.push(rolReal === 'admin' ? '/admin' : '/recepcion')
  } catch (e) {
    console.error('Error login:', e)
    const status = e.response?.status
    if (status === 401) {
      mostrarAlerta('Correo o contraseña incorrectos.', 'error')
    } else if (status === 422) {
      mostrarAlerta('Revisa los datos: el correo no tiene un formato válido.', 'error')
    } else {
      mostrarAlerta(
        e.response?.data?.message || 'No se pudo conectar con el servidor.',
        'error'
      )
    }
  } finally {
    cargando.value = false
  }
}
</script>
