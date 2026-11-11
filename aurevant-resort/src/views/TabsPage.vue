<template>
  <ion-page>
    <ion-tabs>
      <ion-router-outlet></ion-router-outlet>

      <!-- BARRA DE NAVEGACIÓN -->
      <ion-tab-bar slot="bottom" class="aurevant-tab-bar">
        <ion-tab-button tab="tab1" href="/tabs/tab1">
          <ion-icon aria-hidden="true" :icon="home" />
          <ion-label>Inicio</ion-label>
        </ion-tab-button>

        <ion-tab-button tab="tab2" href="/tabs/tab2">
          <ion-icon aria-hidden="true" :icon="bed" />
          <ion-label>Hotel</ion-label>
        </ion-tab-button>

        <ion-tab-button tab="tab3" href="/tabs/tab3">
          <ion-icon aria-hidden="true" :icon="restaurant" />
          <ion-label>Restaurante</ion-label>
        </ion-tab-button>

        <ion-tab-button tab="tab4" href="/tabs/tab4">
          <ion-icon aria-hidden="true" :icon="wine" />
          <ion-label>Bar</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  </ion-page>
</template>

<script setup lang="ts">
import { IonTabBar, IonTabButton, IonTabs, IonLabel, IonIcon, IonPage, IonRouterOutlet } from '@ionic/vue'
import { home, bed, restaurant, wine } from 'ionicons/icons'
</script>

<style scoped>
.aurevant-tab-bar {
  --background: #0F3D2E;
  --border: 1px solid rgba(212, 180, 131, 0.35);
  --color: #F7EFE3;
  --color-selected: #D4B483;

  height: 68px;
  padding-top: 5px;
  padding-bottom: env(safe-area-inset-bottom, 0px);
}

.aurevant-tab-bar ion-tab-button {
  --background: #0F3D2E;
  --background-focused: #174b3a;
  --color: #F7EFE3;
  --color-selected: #D4B483;

  font-size: 12px;
  font-weight: 500;
}

.aurevant-tab-bar ion-tab-button ion-icon {
  font-size: 24px;
  margin-bottom: 3px;
}

.aurevant-tab-bar ion-tab-button.tab-selected {
  --color: #D4B483;
}

.aurevant-tab-bar ion-tab-button ion-label {
  font-size: 11px;
  font-weight: 600;
  margin-top: 2px;
}

.aurevant-tab-bar ion-tab-button::part(native) {
  transition: color 0.2s ease;
}
</style>