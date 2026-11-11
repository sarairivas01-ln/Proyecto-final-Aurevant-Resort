<template>
  <ion-page>
    <ion-content :fullscreen="true" class="home-content">
      <!-- PORTADA -->
      <section class="hero">
        <div class="hero-overlay">
          <div class="brand">
            <span class="brand-symbol">✧</span>
            <h1>AUREVANT</h1>
            <p class="brand-subtitle">R E S O R T</p>
            <div class="brand-line"></div>
            <p class="slogan">El lujo encuentra su altura</p>
          </div>
        </div>
      </section>

      <!-- BIENVENIDA -->
      <section class="welcome-layout">
        <div class="welcome-copy">
          <span class="eyebrow">BIENVENIDO A TU REFUGIO</span>

          <h2>AUREVANT Resort — El lujo encuentra su altura</h2>

          <p>
            AUREVANT Resort nace de la idea de crear un lugar único donde el lujo, la naturaleza y la tranquilidad se
            unen para ofrecer una experiencia inolvidable. Inspirado en la majestuosidad de las montañas y la belleza de
            los paisajes naturales, AUREVANT representa un refugio exclusivo para quienes desean escapar de la rutina y
            disfrutar de momentos especiales.<br><br>
            Su nombre transmite elegancia, distinción y una sensación de grandeza, reflejando la esencia de un resort
            moderno diseñado para brindar comodidad, descanso y experiencias de alta calidad.<br>
            AUREVANT Resort integra tres espacios principales: un hotel con habitaciones acogedoras y elegantes, un
            restaurante que ofrece una experiencia gastronómica especial y un bar ideal para disfrutar de bebidas y
            momentos agradables en un ambiente sofisticado.<br><br>
            Más que un lugar para hospedarse, AUREVANT busca convertirse en un destino donde cada detalle importa, desde
            la atención personalizada hasta la armonía entre sus instalaciones y el entorno natural. Su identidad
            visual, inspirada en el verde bosque, el dorado champagne y los tonos crema, representa la conexión con la
            naturaleza, el lujo y la serenidad.<br><br>
            Con una visión enfocada en la innovación y la satisfacción de sus visitantes, AUREVANT Resort incorpora
            herramientas tecnológicas para facilitar la consulta de servicios y la gestión de reservaciones, ofreciendo
            una experiencia moderna, cómoda y accesible.<br><br>
            AUREVANT Resort es más que un destino: es una experiencia creada para descansar, disfrutar y descubrir una
            nueva forma de vivir el lujo, donde cada visita se convierte en un recuerdo especial.<br><br>
            <b><i>El lujo encuentra su altura.</i></b>
          </p>
        </div>

        <!-- ACCESOS CON ICONOS Y BOTONES -->
        <div class="resort-info">
          <span class="eyebrow">Descubre AUREVANT Resort</span>
          <p class="resort-description">
            Explora nuestros espacios y encuentra la experiencia
            perfecta para ti.
          </p>

          <div class="quick-links">
            <!-- HABITACIONES -->
            <article class="quick-link-card">
              <div class="quick-link-icon">
                <ion-icon :icon="bedOutline" />
              </div>

              <div class="quick-link-text">
                <h4>Habitaciones</h4>
                <p>
                  Descansa con comodidad y disfruta de vistas
                  extraordinarias.
                </p>
              </div>

              <ion-button expand="block" class="explore-button" @click="irA('/tabs/tab2')">
                Explorar habitaciones
                <ion-icon slot="end" :icon="arrowForwardOutline" />
              </ion-button>
            </article>

            <!-- RESTAURANTE -->
            <article class="quick-link-card">
              <div class="quick-link-icon">
                <ion-icon :icon="restaurantOutline" />
              </div>

              <div class="quick-link-text">
                <h4>Restaurante</h4>
                <p>
                  Descubre sabores únicos en un ambiente elegante.
                </p>
              </div>

              <ion-button expand="block" class="explore-button" @click="irA('/tabs/tab3')">
                Conocer restaurante
                <ion-icon slot="end" :icon="arrowForwardOutline" />
              </ion-button>
            </article>

            <!-- BAR -->
            <article class="quick-link-card">
              <div class="quick-link-icon">
                <ion-icon :icon="wineOutline" />
              </div>

              <div class="quick-link-text">
                <h4>Bar</h4>
                <p>
                  Disfruta de bebidas especiales y momentos únicos.
                </p>
              </div>

              <ion-button expand="block" class="explore-button" @click="irA('/tabs/tab4')">
                Descubrir el bar
                <ion-icon slot="end" :icon="arrowForwardOutline" />
              </ion-button>
            </article>
          </div>
        </div>
      </section>

      <!-- SERVICIOS Y EXPERIENCIAS -->
      <section class="section services-section">
        <div class="section-heading">
          <span class="eyebrow">DESCUBRE AUREVANT</span>
          <h2>Nuestros servicios y experiencias</h2>
          <p>
            Disfruta de experiencias diseñadas para tu descanso,
            bienestar y entretenimiento.
          </p>
        </div>

        <div class="services-grid">
          <article v-for="servicio in servicios" :key="servicio.nombre" class="service-card">
            <div class="service-image">
              <img :src="servicio.imagen" :alt="servicio.nombre" />
            </div>

            <div class="service-info">
              <span class="service-category">
                {{ servicio.categoria }}
              </span>

              <h3>{{ servicio.nombre }}</h3>
              <p>{{ servicio.descripcion }}</p>

              <div class="service-activities">
                <span v-for="actividad in servicio.actividades" :key="actividad">
                  <ion-icon :icon="checkmarkCircleOutline" />
                  {{ actividad }}
                </span>
              </div>
            </div>
          </article>
        </div>
      </section>

      <!-- EXPERIENCIA -->
      <section class="experience-section">
        <div class="experience-image">
          <img src="https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?auto=format&fit=crop&w=1400&q=85"
            alt="Cabaña rodeada de naturaleza" />

          <div class="experience-overlay">
            <span>DESCANSO Y TRANQUILIDAD</span>
            <h2>Tu próximo escape comienza aquí.</h2>
            <p>
              Respira, desconecta y disfruta de lo extraordinario.
            </p>
          </div>
        </div>
      </section>

      <!-- FOOTER -->
      <footer class="footer">
        <div class="footer-symbol">✧</div>
        <h2>AUREVANT RESORT</h2>
        <p>El lujo encuentra su altura</p>

        <div class="footer-contact">
          <p>
            <ion-icon :icon="locationOutline" />
            Altos de Mira Monte, Chalatenango
          </p>

          <p>
            <ion-icon :icon="callOutline" />
            2500-0230
          </p>
        </div>

        <div class="footer-line"></div>
        <small>EXCLUSIVIDAD · NATURALEZA · BIENESTAR</small>
      </footer>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

import {
  IonPage,
  IonContent,
  IonButton,
  IonIcon
} from '@ionic/vue';

import {
  locationOutline,
  callOutline,
  checkmarkCircleOutline,
  bedOutline,
  restaurantOutline,
  wineOutline,
  arrowForwardOutline
} from 'ionicons/icons';

const router = useRouter();

/* NAVEGACIÓN ENTRE TABS */
function irA(ruta: string) {
  router.push(ruta);
}

interface Servicio {
  nombre: string;
  categoria: string;
  descripcion: string;
  imagen: string;
  actividades: string[];
}

/* SERVICIOS */
const servicios: Servicio[] = [
  {
    nombre: 'Piscinas y relajación',
    categoria: 'DESCANSO Y RELAJACIÓN',
    descripcion:
      'Espacios para desconectarte y disfrutar de un ambiente tranquilo.',
    imagen:
      'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?auto=format&fit=crop&w=900&q=85',
    actividades: [
      'Piscina panorámica',
      'Jacuzzi',
      'Zonas de descanso'
    ]
  },
  {
    nombre: 'Spa y bienestar',
    categoria: 'BIENESTAR PERSONAL',
    descripcion:
      'Experiencias orientadas al descanso y cuidado personal.',
    imagen:
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=900&q=85',
    actividades: [
      'Masajes',
      'Tratamientos corporales',
      'Sauna y espacios de relajación'
    ]
  },
  {
    nombre: 'Naturaleza y aventura',
    categoria: 'AVENTURA NATURAL',
    descripcion:
      'Explora el entorno natural y descubre paisajes especiales.',
    imagen:
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=900&q=85',
    actividades: [
      'Caminatas por senderos',
      'Visitas a miradores',
      'Recorridos guiados'
    ]
  },
  {
    nombre: 'Deporte y recreación',
    categoria: 'ACTIVIDAD Y MOVIMIENTO',
    descripcion:
      'Alternativas para mantenerte activo durante tu estancia.',
    imagen:
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=900&q=85',
    actividades: [
      'Gimnasio',
      'Yoga',
      'Actividades recreativas'
    ]
  },
  {
    nombre: 'Experiencias especiales',
    categoria: 'MOMENTOS INOLVIDABLES',
    descripcion:
      'Celebra ocasiones especiales y comparte momentos únicos.',
    imagen:
      'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=900&q=85',
    actividades: [
      'Paquetes románticos',
      'Celebraciones',
      'Experiencias gastronómicas'
    ]
  }
];
</script>

<style scoped>
.home-content {
  --background: #f6f1e7;
  --color: #202a24;
  font-family: Georgia, 'Times New Roman', serif;
}

/* PORTADA */
.hero {
  min-height: 570px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fffaf0;
  background-image: url('https://images.openai.com/static-rsc-4/eo8ivNrbXmeD0gnG6gBBPWDJRqBin9MWg_qgxUzAfiivRJDlDPZng3LgKJF50BW9kbJ_6h62gU0L96zp4rmlEHfNs7OvkbnHKTTX62x01q5x74bYQJbxjkEDSykoKmNyYP2eNv49o_SJRanqjf6L0hEnytbYx165xd822HTKn4Jk8vTmhIDd65ZAC5YXvUI3?purpose=fullsize');
  background-size: cover;
  background-position: center;
}

.hero-overlay {
  width: 100%;
  min-height: 570px;
  box-sizing: border-box;
  padding: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: linear-gradient(180deg,
      rgba(7, 37, 27, 0.42),
      rgba(7, 37, 27, 0.25) 45%,
      rgba(7, 37, 27, 0.78));
}

.brand {
  width: 100%;
  text-align: center;
}

.brand-symbol {
  display: block;
  color: #f6f1e7;
  font-size: 43px;
  line-height: 1;
  margin-bottom: 10px;
}

.brand h1 {
  font-size: clamp(36px, 8vw, 58px);
  font-weight: 400;
  letter-spacing: 8px;
  margin: 8px 0 4px;
}

.brand-subtitle {
  color: #f6f1e7;
  font-size: 25px;
  letter-spacing: 6px;
  margin: 8px 0 0;
}

.brand-line {
  height: 2px;
  width: 55px;
  background: #d7b574;
  margin: 22px auto 0;
}

.slogan {
  font-size: 16px;
  font-style: italic;
  margin: 15px 0 0;
}

/* TEXTOS GENERALES */
.eyebrow {
  color: #a27c3e;
  font-family: Arial, sans-serif;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 2px;
}

.section {
  padding: 42px 21px;
}

.section-heading {
  margin-bottom: 24px;
}

.section-heading h2 {
  color: #0f3d2e;
  font-size: clamp(28px, 5vw, 36px);
  line-height: 1.2;
  font-weight: 400;
  margin: 10px 0;
}

.section-heading p {
  color: #667067;
  font-family: Arial, sans-serif;
  font-size: 14px;
  line-height: 1.7;
  max-width: 600px;
  margin: 0;
}

/* BIENVENIDA */
.welcome-layout {
  display: grid;
  grid-template-columns: 1fr;
  gap: 32px;
  padding: 42px 21px;
  background: #fffdf7;
}

.welcome-copy h2 {
  color: #0f3d2e;
  font-size: clamp(32px, 6vw, 46px);
  line-height: 1.16;
  font-weight: 400;
  margin: 14px 0 18px;
}

.welcome-copy p {
  color: #667067;
  font-family: Arial, sans-serif;
  font-size: 14px;
  line-height: 1.85;
}

/* CONÓCENOS: ACCESOS A LAS TABS */
.resort-info {
  padding: 24px;
  border: 1px solid #e3dac9;
  border-radius: 18px;
  background: #f6f1e7;
}

.resort-info h3 {
  color: #0f3d2e;
  font-size: 25px;
  font-weight: 400;
  margin: 12px 0 10px;
}

.resort-description {
  color: #667067;
  font-family: Arial, sans-serif;
  font-size: 13px;
  line-height: 1.7;
  margin: 0 0 20px;
}

.quick-links {
  display: grid;
  grid-template-columns: 1fr;
  gap: 15px;
}

.quick-link-card {
  padding: 18px;
  background: #fffdf7;
  border: 1px solid #e3dac9;
  border-radius: 15px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.quick-link-card:active {
  transform: scale(0.99);
}

.quick-link-icon {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 14px;
  background: #0f3d2e;
  color: #d7b574;
  font-size: 26px;
  margin-bottom: 13px;
}

.quick-link-text h4 {
  color: #0f3d2e;
  font-size: 19px;
  font-weight: 400;
  margin: 0 0 7px;
}

.quick-link-text p {
  color: #667067;
  font-family: Arial, sans-serif;
  font-size: 12px;
  line-height: 1.7;
  margin: 0 0 15px;
}

.explore-button {
  --background: #0f3d2e;
  --background-activated: #20533e;
  --background-hover: #20533e;
  --color: #fffaf0;
  --border-radius: 24px;
  --box-shadow: none;

  width: 100%;
  min-height: 43px;
  margin: 0;
  font-family: Arial, sans-serif;
  font-size: 11px;
  font-weight: 600;
  text-transform: none;
}

.explore-button ion-icon {
  font-size: 17px;
}

/* SERVICIOS */
.services-section {
  background: #f6f1e7;
}

.services-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 22px;
}

.service-card {
  overflow: hidden;
  border: 1px solid #e3dac9;
  border-radius: 17px;
  background: #fffdf7;
  box-shadow: 0 5px 16px rgba(25, 48, 35, 0.07);
}

.service-image {
  height: 215px;
  overflow: hidden;
  background: #123b2b;
}

.service-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.service-info {
  padding: 21px;
}

.service-category {
  color: #946e32;
  font-family: Arial, sans-serif;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.5px;
}

.service-info h3 {
  color: #0f3d2e;
  font-size: 25px;
  font-weight: 400;
  line-height: 1.25;
  margin: 10px 0;
}

.service-info>p {
  color: #667067;
  font-family: Arial, sans-serif;
  font-size: 13px;
  line-height: 1.7;
}

.service-activities {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 17px;
}

.service-activities span {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  color: #435849;
  font-family: Arial, sans-serif;
  font-size: 12px;
  line-height: 1.5;
}

.service-activities ion-icon {
  flex-shrink: 0;
  color: #a27c3e;
  font-size: 17px;
}

/* EXPERIENCIA */
.experience-section {
  padding: 0;
  background: #f6f1e7;
}

.experience-image {
  height: 310px;
  position: relative;
  overflow: hidden;
  background: #123b2b;
}

.experience-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.experience-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 28px 22px;
  color: #fffaf0;
  background: linear-gradient(transparent 10%,
      rgba(5, 31, 22, 0.88));
}

.experience-overlay span {
  color: #e3c589;
  font-family: Arial, sans-serif;
  font-size: 10px;
  letter-spacing: 2px;
}

.experience-overlay h2 {
  max-width: 500px;
  font-size: 30px;
  line-height: 1.2;
  font-weight: 400;
  margin: 10px 0;
}

.experience-overlay p {
  font-family: Arial, sans-serif;
  font-size: 13px;
  line-height: 1.6;
  margin: 0;
}

/* FOOTER */
.footer {
  background: #0f3d2e;
  color: #f8f1e5;
  text-align: center;
  padding: 34px 15px 28px;
}

.footer-symbol {
  color: #d7b574;
  font-size: 30px;
}

.footer h2 {
  font-size: 19px;
  letter-spacing: 4px;
  font-weight: 400;
  margin: 10px 0;
}

.footer>p {
  color: #d7b574;
  font-size: 13px;
  font-style: italic;
}

.footer-contact {
  margin-top: 22px;
}

.footer-contact p {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 9px;
  color: #e0e4dc;
  font-family: Arial, sans-serif;
  font-size: 12px;
  line-height: 1.6;
}

.footer-contact ion-icon {
  color: #d7b574;
  font-size: 17px;
}

.footer-line {
  height: 1px;
  width: 65px;
  background: #b89960;
  margin: 22px auto;
}

.footer small {
  font-family: Arial, sans-serif;
  font-size: 9px;
  letter-spacing: 1.5px;
  color: #d5ded6;
}

/* TABLET Y ESCRITORIO */
@media (min-width: 700px) {

  .hero,
  .hero-overlay {
    min-height: 650px;
  }

  .hero {
    background-position: center 55%;
  }

  .brand h1 {
    font-size: 58px;
  }

  .welcome-layout {
    grid-template-columns: 1.1fr 0.9fr;
    align-items: center;
    gap: 7%;
    padding: 65px 7%;
  }

  .quick-links {
    grid-template-columns: 1fr;
  }

  .section {
    padding-left: 7%;
    padding-right: 7%;
  }

  .services-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 25px;
  }

  .service-card {
    display: flex;
    flex-direction: column;
  }

  .service-image {
    height: 230px;
  }

  .service-info {
    flex: 1;
  }

  .experience-image {
    height: 400px;
  }

  .experience-overlay {
    padding: 45px 7%;
  }

  .experience-overlay h2 {
    font-size: 40px;
  }
}

@media (max-width: 380px) {
  .brand h1 {
    letter-spacing: 5px;
  }

  .resort-info {
    padding: 17px;
  }

  .quick-link-card {
    padding: 15px;
  }
}
</style>