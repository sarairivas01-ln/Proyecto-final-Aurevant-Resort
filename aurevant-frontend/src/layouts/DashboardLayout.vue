<template>
  <v-app>
    <v-navigation-drawer permanent width="230" color="#0F3D2E" class="sidebar">
      <div class="brand">
        <img :src="require('@/assets/logo.png')" alt="AUREVANT Resort" class="brand-logo" />
        <div class="brand-name">AUREVANT</div>
        <div class="brand-sub">R E S O R T</div>
        <div class="brand-tag">El lujo encuentra su altura</div>
      </div>
      <v-list nav density="comfortable" class="px-3">
        <v-list-item
          v-for="item in menu"
          :key="item.to"
          :to="item.to"
          :prepend-icon="item.icon"
          :title="item.title"
          rounded="lg"
          class="nav-item mb-1"
          active-class="nav-active"
        />
      </v-list>
      <template #append>
        <v-divider class="mx-4 mb-2" color="#D4B483" opacity="0.3" />
        <v-list nav density="comfortable" class="px-3 pb-3">
          <v-list-item prepend-icon="mdi-logout" title="Cerrar sesión" class="nav-item" rounded="lg" @click="salir" />
        </v-list>
      </template>
    </v-navigation-drawer>
    <v-app-bar flat color="#FFFFFF" height="64" class="topbar">
      <v-spacer />
      <v-btn icon="mdi-bell-outline" variant="text" color="#1A1A1A" />
      <v-menu>
        <template #activator="{ props }">
          <v-btn v-bind="props" variant="text" color="#1A1A1A" prepend-icon="mdi-account-circle">
            {{ rolLabel }}
            <v-icon end>mdi-chevron-down</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item title="Mi perfil" prepend-icon="mdi-account-outline" />
          <v-list-item title="Cerrar sesión" prepend-icon="mdi-logout" @click="salir" />
        </v-list>
      </v-menu>
    </v-app-bar>
    <v-main>
      <v-container fluid class="pa-6">
        <router-view />
      </v-container>
    </v-main>
  </v-app>
</template>
<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
const store = useStore()
const router = useRouter()
const rolLabel = computed(() => (store.getters['auth/isAdmin'] ? 'Administrador' : 'Recepcionista'))
const menuAdmin = [
  { title: 'Inicio', icon: 'mdi-home-outline', to: '/admin' },
  { title: 'Habitaciones', icon: 'mdi-bed-outline', to: '/admin/habitaciones' },
  { title: 'Platillos', icon: 'mdi-silverware-fork-knife', to: '/admin/platillos' },
  { title: 'Reservaciones', icon: 'mdi-calendar-blank-outline', to: '/admin/reservaciones' },
  { title: 'Clientes', icon: 'mdi-account-group-outline', to: '/admin/clientes' },
  { title: 'Servicios', icon: 'mdi-spa', to: '/admin/servicios' }
]
const menuRecepcion = [
  { title: 'Inicio', icon: 'mdi-home-outline', to: '/recepcion' },
  { title: 'Reservaciones', icon: 'mdi-bed-outline', to: '/recepcion/reservas' },
  { title: 'Clientes', icon: 'mdi-account-group-outline', to: '/recepcion/clientes' },
  { title: 'Restaurante / Bar', icon: 'mdi-silverware-fork-knife', to: '/recepcion/restaurante' },
  { title: 'Solicitudes', icon: 'mdi-bell-outline', to: '/recepcion/solicitudes' },
  { title: 'Servicios', icon: 'mdi-spa', to: '/recepcion/servicios' }
]
const menu = computed(() => (store.getters['auth/isAdmin'] ? menuAdmin : menuRecepcion))
function salir() {
  store.dispatch('auth/logout')
  router.push('/login')
}
</script>
<style scoped>
.sidebar { border-right: none !important; }
.brand {
  text-align: center;
  padding: 26px 16px 22px;
  color: #F7EFE3;
}
.brand-logo {
  width: 160px;
  height: auto;
  display: block;
  margin: 0 auto 10px;
}
.brand-name {
  font-family: 'Cormorant Garamond', 'Times New Roman', serif;
  font-size: 19px;
  letter-spacing: 7px;
  color: #F7EFE3;
}
.brand-sub {
  font-size: 9px;
  letter-spacing: 7px;
  color: #D4B483;
  margin-top: 2px;
}
.brand-tag {
  font-family: 'Cormorant Garamond', serif;
  font-style: italic;
  font-size: 10px;
  color: #D4B483;
  opacity: 0.85;
  margin-top: 8px;
}
.nav-item {
  color: #E9E1D2 !important;
  font-size: 14px;
}
.nav-item:hover {
  background: rgba(212, 180, 131, 0.12) !important;
}
.nav-active {
  background: rgba(212, 180, 131, 0.18) !important;
  color: #D4B483 !important;
  border-left: 3px solid #D4B483;
}
.topbar { border-bottom: 1px solid rgba(212, 180, 131, 0.35) !important; }
</style>
