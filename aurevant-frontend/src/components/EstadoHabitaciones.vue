<template>
  <v-card class="pa-5">
    <div class="d-flex justify-space-between align-center mb-4">
      <span class="text-subtitle-1 font-weight-bold">Estado de habitaciones</span>
      <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right">Ver todos</v-btn>
    </div>
    <div class="d-flex align-center ga-6">
      <v-progress-circular
        :model-value="porcentajeOcupadas"
        :size="110"
        :width="14"
        color="secondary"
        bg-color="#EFE4D2"
      >
        <div class="text-center">
          <div class="text-h6 font-weight-bold">{{ total }}</div>
          <div class="text-caption">Total</div>
        </div>
      </v-progress-circular>
      <div class="flex-grow-1">
        <div v-for="e in estados" :key="e.label" class="d-flex align-center justify-space-between mb-2">
          <div class="d-flex align-center ga-2">
            <span class="dot" :style="{ background: e.color }" />
            <span class="text-body-2">{{ e.label }}</span>
          </div>
          <span class="text-body-2 font-weight-medium">{{ e.valor }}</span>
        </div>
      </div>
    </div>
  </v-card>
</template>
<script setup>
import { computed } from 'vue'
const props = defineProps({
  total: { type: Number, default: 20 },
  disponibles: { type: Number, default: 15 },
  ocupadas: { type: Number, default: 4 },
  mantenimiento: { type: Number, default: 1 }
})
const porcentajeOcupadas = computed(() =>
  props.total ? Math.round((props.ocupadas / props.total) * 100) : 0
)
const estados = computed(() => [
  { label: 'Disponibles', valor: props.disponibles, color: '#0F3D2E' },
  { label: 'Ocupadas', valor: props.ocupadas, color: '#D4B483' },
  { label: 'Mantenimiento', valor: props.mantenimiento, color: '#8A8578' }
])
</script>
<style scoped>
.dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; }
</style>
