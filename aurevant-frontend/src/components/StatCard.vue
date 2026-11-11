<template>
  <div class="kpi pa-4">
    <div class="d-flex align-center">
      <div class="kpi-icon mr-3">
        <v-icon color="#0F3D2E">{{ icon }}</v-icon>
      </div>
      <div>
        <div class="kpi-label">{{ label }}</div>
        <div class="kpi-value">{{ value }}</div>
      </div>
    </div>
    <div v-if="hint" class="kpi-hint mt-2">{{ hint }}</div>
    <v-progress-linear
      v-if="progress !== null"
      :model-value="progress"
      height="6"
      rounded
      color="#0F3D2E"
      bg-color="#E9E1D2"
      class="mt-3"
    />
  </div>
</template>

<script setup>
defineProps({
  icon: String,
  label: String,
  value: [String, Number],
  hint: String,
  progress: { type: Number, default: null }
})
</script>

<style scoped>
.kpi {
  background: #FFFFFF;
  border: 1px solid rgba(212, 180, 131, 0.45);
  border-radius: 12px;
  height: 100%;
}
.kpi-icon {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: #F7EFE3;
  display: flex;
  align-items: center;
  justify-content: center;
}
.kpi-label { font-size: 12px; color: #6B6B6B; }
.kpi-value { font-size: 26px; font-weight: 600; color: #1A1A1A; line-height: 1.1; }
.kpi-hint { font-size: 11px; color: #8A8A8A; }
</style>
