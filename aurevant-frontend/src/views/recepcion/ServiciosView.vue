<template>
  <v-container fluid class="pa-0">
    <div class="mb-6">
      <h2 class="page-title">Servicios</h2>
      <p class="page-sub">Comodidades y experiencias disponibles en AUREVANT Resort.</p>
    </div>
    <v-row dense>
      <v-col v-for="s in servicios" :key="s.titulo" cols="12" sm="6" md="4">
        <v-card class="servicio" elevation="0">
          <v-img :src="s.img" height="170" cover class="servicio-img">
            <template #placeholder>
              <div class="img-placeholder">
                <v-icon size="28" color="#D4B483">mdi-image-outline</v-icon>
              </div>
            </template>
          </v-img>
          <div class="pa-5">
            <div class="servicio-cat">{{ s.categoria }}</div>
            <div class="servicio-titulo">{{ s.titulo }}</div>
            <p class="servicio-desc">{{ s.descripcion }}</p>
            <div v-if="s.items?.length" class="mt-3">
              <div v-for="i in s.items" :key="i" class="servicio-item">
                <v-icon size="14" color="#0F3D2E">mdi-check-circle-outline</v-icon>
                <span>{{ i }}</span>
              </div>
            </div>
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script setup>
const servicios = [
  {
    categoria: 'Descanso y relajación',
    titulo: 'Piscinas y relajación',
    descripcion: 'Espacios para desconectarte y disfrutar de un ambiente tranquilo.',
    img: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
    items: ['Piscina panorámica', 'Jacuzzi', 'Zonas de descanso']
  },
  {
    categoria: 'Bienestar personal',
    titulo: 'Spa y bienestar',
    descripcion: 'Experiencias orientadas al descanso y cuidado personal.',
    img: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
    items: ['Masajes', 'Tratamientos corporales', 'Sauna y espacios de relajación']
  },
  {
    categoria: 'Aventura natural',
    titulo: 'Naturaleza y aventura',
    descripcion: 'Explora el entorno natural y descubre paisajes especiales.',
    img: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
    items: ['Caminatas por senderos', 'Visitas a miradores', 'Recorridos guiados']
  },
  {
    categoria: 'Actividad y movimiento',
    titulo: 'Deporte y recreación',
    descripcion: 'Alternativas para mantenerte activo durante tu estancia.',
    img: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
    items: ['Gimnasio', 'Yoga', 'Actividades recreativas']
  },
  {
    categoria: 'Momentos inolvidables',
    titulo: 'Experiencias especiales',
    descripcion: 'Celebra ocasiones especiales y comparte momentos únicos.',
    img: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
    items: ['Eventos privados', 'Cenas especiales', 'Decoración personalizada']
  }
]
</script>
<style scoped>
.page-title { font-family: 'Cormorant Garamond', serif; font-size: 26px; color: #1A1A1A; }
.page-sub { font-size: 13px; color: #6B6B6B; }
.servicio {
  background: #FFFFFF;
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  overflow: hidden;
  height: 100%;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}
.servicio:hover {
  box-shadow: 0 8px 24px rgba(15, 61, 46, 0.12);
  transform: translateY(-2px);
}
.servicio-img { border-bottom: 1px solid rgba(212, 180, 131, 0.3); }
.img-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  background: #F7EFE3;
}
.servicio-cat {
  font-size: 10px;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #D4B483;
  font-weight: 600;
}
.servicio-titulo {
  font-family: 'Cormorant Garamond', serif;
  font-size: 21px;
  color: #0F3D2E;
  margin: 4px 0 6px;
}
.servicio-desc { font-size: 12.5px; color: #6B6B6B; line-height: 1.5; }
.servicio-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12.5px;
  color: #3A3A3A;
  margin-bottom: 6px;
}
</style>
