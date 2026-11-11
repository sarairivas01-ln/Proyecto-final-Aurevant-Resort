<template>
  <ion-page>
    <ion-content :fullscreen="true" class="hotel-content">
      <!-- PORTADA -->
      <section class="hero">
        <img class="hero-image"
          src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1800&q=90"
          alt="Habitación de lujo de AUREVANT Resort" />
        <div class="hero-overlay"></div>
        <div class="hero-content">
          <span class="eyebrow">AUREVANT RESORT</span>
          <h1>Hotel</h1>
          <div class="gold-line"></div>
          <p>Tu refugio de lujo entre las montañas</p>
        </div>
      </section>

      <!-- HABITACIONES -->
      <section class="rooms-section">
        <div class="section-title">
          <span class="eyebrow">ENCUENTRA TU ESPACIO</span>
          <h2>Nuestras habitaciones</h2>
          <p>Encuentra el espacio perfecto para tu estancia.</p>
        </div>

        <!-- HABITACIONES CARGADAS DESDE LARAVEL -->
        <div v-if="cargandoHabitaciones" class="rooms-message">
          Cargando habitaciones disponibles...
        </div>

        <div v-else-if="errorHabitaciones" class="rooms-message error-message">
          {{ errorHabitaciones }}
          <ion-button fill="clear" @click="cargarHabitaciones">
            Intentar nuevamente
          </ion-button>
        </div>

        <div v-else-if="habitaciones.length === 0" class="rooms-message">
          Actualmente no hay habitaciones disponibles.
        </div>

        <article v-for="habitacion in habitaciones" :key="habitacion.id_habitacion" class="room-card">
          <img :src="habitacion.img_url || imagenHabitacion" :alt="`Habitación ${habitacion.numero}`" />

          <div class="room-info">
            <span class="room-category">
              {{ habitacion.vista || 'AUREVANT RESORT' }}
            </span>

            <h3>{{ habitacion.tipo }} · {{ habitacion.numero }}</h3>

            <p>
              {{ habitacion.descripcion ||
                'Un espacio diseñado para disfrutar una estancia cómoda y exclusiva.' }}
            </p>

            <div class="room-details">
              <span>
                <ion-icon :icon="peopleOutline" />
                {{ habitacion.capacidad }} personas
              </span>

              <span>
                <ion-icon :icon="bedOutline" />
                {{ habitacion.balcon ? 'Con balcón' : 'Interior' }}
              </span>
            </div>

            <div class="room-bottom">
              <div class="price">
                <strong>{{ formatearPrecio(habitacion.precio_noche) }}</strong>
                <span> / noche</span>
              </div>

              <ion-button class="room-button" @click="abrirReserva(habitacion)">
                Elegir
              </ion-button>
            </div>
          </div>
        </article>

        <!-- RESERVACIÓN GENERAL -->
        <div class="reservation-area">
          <span class="eyebrow">TU PRÓXIMA EXPERIENCIA</span>
          <h2>¿Listo para tu estancia?</h2>
          <p>Completa tus datos y prepara tu visita a AUREVANT.</p>

          <ion-button expand="block" class="reserve-main-button" @click="abrirReserva()">
            <ion-icon slot="start" />
            Reservar habitación
          </ion-button>
        </div>
      </section>

      <!-- FORMULARIO DE RESERVACIÓN -->
      <ion-modal :is-open="modalAbierto" @didDismiss="cerrarModal" class="reservation-modal">
        <ion-header>
          <ion-toolbar class="modal-toolbar">
            <ion-title>Reservar habitación</ion-title>

            <ion-buttons slot="end">
              <ion-button @click="cerrarModal" aria-label="Cerrar reservación">
                <ion-icon :icon="closeOutline" />
              </ion-button>
            </ion-buttons>
          </ion-toolbar>
        </ion-header>

        <ion-content class="modal-content">
          <div class="form-intro">
            <span class="eyebrow">AUREVANT RESORT</span>
            <h2>Planifica tu estancia</h2>
            <p>Completa la información de tu reservación.</p>
          </div>

          <form class="reservation-form" @submit.prevent="enviarReserva">

            <!-- NOMBRE -->
            <ion-item class="form-item">
              <ion-input v-model="reserva.nombre" label="Nombre completo" label-placement="stacked"
                placeholder="Escribe tu nombre" required />
            </ion-item>

            <!-- DUI -->
            <ion-item class="form-item">
              <ion-input v-model="reserva.dui" type="text" label="DUI" label-placement="stacked"
                placeholder="00000000-0" :maxlength="10" required />
            </ion-item>

            <!-- TELÉFONO -->
            <ion-item class="form-item">
              <ion-input v-model="reserva.telefono" type="tel" label="Teléfono" label-placement="stacked"
                placeholder="Tu número de contacto" required />
            </ion-item>

            <!-- CORREO ELECTRÓNICO -->
            <ion-item class="form-item">
              <ion-input v-model="reserva.email" type="email" label="Correo electrónico" label-placement="stacked"
                placeholder="ejemplo@correo.com" required />
            </ion-item>

            <!-- HABITACIÓN -->
            <ion-item class="form-item select-item">
              <ion-select :value="habitacionSeleccionada?.id_habitacion ?? ''" label="Habitación"
                label-placement="stacked" placeholder="Selecciona una habitación" interface="popover"
                @ionChange="seleccionarHabitacion($event.detail.value)" required>
                <ion-select-option v-for="habitacion in habitaciones" :key="habitacion.id_habitacion"
                  :value="habitacion.id_habitacion">
                  {{ habitacion.tipo }} · {{ habitacion.numero }} —
                  {{ formatearPrecio(habitacion.precio_noche) }} / noche
                </ion-select-option>
              </ion-select>
            </ion-item>

            <!-- PERSONAS -->
            <div class="form-grid">
              <ion-item class="form-item">
                <ion-input v-model.number="reserva.personas" type="number" min="1"
                  :max="habitacionSeleccionada?.capacidad || 20" label="Personas" label-placement="stacked" required />
              </ion-item>
            </div>

            <!-- FECHAS DE ENTRADA Y SALIDA -->
            <div class="date-grid">
              <button type="button" class="date-field" @click="abrirCalendario('entrada')">
                <span class="date-icon">
                  <ion-icon :icon="calendarOutline" />
                </span>

                <span class="date-copy">
                  <span class="date-label">Fecha de entrada</span>
                  <strong>
                    {{
                      reserva.entrada
                        ? formatearFecha(reserva.entrada)
                        : 'Seleccionar fecha'
                    }}
                  </strong>
                </span>

                <ion-icon class="date-chevron" :icon="chevronDownOutline" />
              </button>

              <button type="button" class="date-field" @click="abrirCalendario('salida')">
                <span class="date-icon">
                  <ion-icon :icon="calendarOutline" />
                </span>

                <span class="date-copy">
                  <span class="date-label">Fecha de salida</span>
                  <strong>
                    {{
                      reserva.salida
                        ? formatearFecha(reserva.salida)
                        : 'Seleccionar fecha'
                    }}
                  </strong>
                </span>

                <ion-icon class="date-chevron" :icon="chevronDownOutline" />
              </button>
            </div>

            <!-- ENVIAR RESERVACIÓN -->
            <ion-button type="submit" expand="block" class="reserve-main-button" :disabled="enviando">
              {{ enviando ? 'Enviando...' : 'Enviar solicitud' }}
            </ion-button>

            <ion-button type="button" expand="block" fill="clear" class="cancel-button" @click="cerrarModal">
              Cancelar
            </ion-button>
          </form>
        </ion-content>
      </ion-modal>

      <!-- CALENDARIO -->
      <ion-modal :is-open="calendarioAbierto" @didDismiss="cerrarCalendario" class="calendar-modal">
        <ion-header>
          <ion-toolbar class="calendar-toolbar">
            <ion-title>
              {{ calendarioObjetivo === 'entrada'
                ? 'Fecha de entrada'
                : 'Fecha de salida' }}
            </ion-title>

            <ion-buttons slot="end">
              <ion-button @click="cerrarCalendario" aria-label="Cerrar calendario">
                <ion-icon :icon="closeOutline" />
              </ion-button>
            </ion-buttons>
          </ion-toolbar>
        </ion-header>

        <ion-content class="calendar-content">
          <p class="calendar-hint">
            Selecciona el día de tu estancia.
          </p>

          <ion-datetime v-model="fechaTemporal" presentation="date" :min="calendarioObjetivo === 'salida'
            ? (reserva.entrada || hoy)
            : hoy" :first-day-of-week="1" locale="es-SV" :show-default-buttons="false" class="aurevant-datetime" />

          <div class="calendar-actions">
            <ion-button fill="clear" class="calendar-cancel" @click="cerrarCalendario">
              Cancelar
            </ion-button>

            <ion-button class="calendar-accept" @click="confirmarFecha">
              Confirmar fecha
            </ion-button>
          </div>
        </ion-content>
      </ion-modal>

      <!-- MENSAJE DE RESULTADO -->
      <ion-alert :is-open="alertaAbierta" header="AUREVANT RESORT" :message="mensajeAlerta" :buttons="['Aceptar']"
        @didDismiss="alertaAbierta = false" />

    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue';

import {
  IonPage,
  IonContent,
  IonButton,
  IonIcon,
  IonModal,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonButtons,
  IonItem,
  IonInput,
  IonSelect,
  IonSelectOption,
  IonAlert,
  IonDatetime
} from '@ionic/vue';

import {
  bedOutline,
  peopleOutline,
  calendarOutline,
  closeOutline,
  chevronDownOutline
} from 'ionicons/icons';

// INTERFAZ DE HABITACIONES
interface Habitacion {
  id_habitacion: number;
  numero: string;
  tipo: string;
  descripcion: string | null;
  precio_noche: number | string;
  capacidad: number;
  vista: string;
  balcon: boolean | number;
  estado: string;
  activa: boolean | number;
  img_url: string | null;
}

type CampoFecha = 'entrada' | 'salida';

// DIRECCIÓN DE LA API
const API_URL = 'http://127.0.0.1:8000/api';

const imagenHabitacion =
  'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=900&q=85';

// VARIABLES
const habitaciones = ref<Habitacion[]>([]);
const cargandoHabitaciones = ref(false);
const errorHabitaciones = ref('');

const habitacionSeleccionada = ref<Habitacion | null>(null);
const enviando = ref(false);

const modalAbierto = ref(false);
const calendarioAbierto = ref(false);
const calendarioObjetivo = ref<CampoFecha>('entrada');
const fechaTemporal = ref('');

const alertaAbierta = ref(false);
const mensajeAlerta = ref('');

// FECHA ACTUAL
const hoy = computed(() => {
  const fecha = new Date();

  const anio = fecha.getFullYear();
  const mes = String(fecha.getMonth() + 1).padStart(2, '0');
  const dia = String(fecha.getDate()).padStart(2, '0');

  return `${anio}-${mes}-${dia}`;
});

// DATOS DEL FORMULARIO
const reserva = reactive({
  nombre: '',
  dui: '',
  telefono: '',
  email: '',
  personas: 2,
  entrada: '',
  salida: ''
});

// CARGAR HABITACIONES AL ABRIR LA PÁGINA
onMounted(() => {
  cargarHabitaciones();
});

// OBTENER HABITACIONES DESDE LARAVEL
async function cargarHabitaciones() {
  cargandoHabitaciones.value = true;
  errorHabitaciones.value = '';

  try {
    const respuesta = await fetch(`${API_URL}/habitaciones-publicas`);

    if (!respuesta.ok) {
      throw new Error('No fue posible cargar las habitaciones.');
    }

    const datos = await respuesta.json();

    habitaciones.value = Array.isArray(datos) ? datos : [];

  } catch (error) {
    errorHabitaciones.value = error instanceof Error
      ? error.message
      : 'Ocurrió un error al conectar con el servidor.';

  } finally {
    cargandoHabitaciones.value = false;
  }
}

// FORMATO DEL PRECIO
function formatearPrecio(precio: number | string) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 2
  }).format(Number(precio));
}

// LIMPIAR FORMULARIO
function limpiarReserva() {
  reserva.nombre = '';
  reserva.dui = '';
  reserva.telefono = '';
  reserva.email = '';
  reserva.personas = 2;
  reserva.entrada = '';
  reserva.salida = '';

  fechaTemporal.value = '';
  calendarioAbierto.value = false;
}

// ABRIR FORMULARIO
function abrirReserva(habitacion: Habitacion | null = null) {
  limpiarReserva();

  habitacionSeleccionada.value = habitacion;

  if (habitacion) {
    reserva.personas = Math.min(2, Number(habitacion.capacidad));
  }

  mensajeAlerta.value = '';
  alertaAbierta.value = false;

  modalAbierto.value = true;
}

// SELECCIONAR HABITACIÓN
function seleccionarHabitacion(id: number | string) {
  habitacionSeleccionada.value =
    habitaciones.value.find(h => h.id_habitacion === Number(id)) || null;

  if (habitacionSeleccionada.value) {
    reserva.personas = Math.min(
      reserva.personas,
      Number(habitacionSeleccionada.value.capacidad)
    );

    if (reserva.personas < 1) {
      reserva.personas = 1;
    }
  }
}

// CERRAR FORMULARIO
function cerrarModal() {
  modalAbierto.value = false;
  calendarioAbierto.value = false;

  limpiarReserva();

  habitacionSeleccionada.value = null;
}

// ABRIR CALENDARIO
function abrirCalendario(campo: CampoFecha) {
  calendarioObjetivo.value = campo;

  fechaTemporal.value = reserva[campo] ||
    (campo === 'salida' ? (reserva.entrada || hoy.value) : hoy.value);

  calendarioAbierto.value = true;
}

// CERRAR CALENDARIO
function cerrarCalendario() {
  calendarioAbierto.value = false;
}

// CONFIRMAR FECHA
function confirmarFecha() {
  if (!fechaTemporal.value) {
    cerrarCalendario();
    return;
  }

  if (calendarioObjetivo.value === 'entrada') {
    reserva.entrada = fechaTemporal.value;

    if (reserva.salida && reserva.salida <= reserva.entrada) {
      reserva.salida = '';
    }

  } else {
    if (reserva.entrada && fechaTemporal.value <= reserva.entrada) {
      mostrarAlerta(
        'La fecha de salida debe ser posterior a la fecha de entrada.'
      );
      return;
    }

    reserva.salida = fechaTemporal.value;
  }

  cerrarCalendario();
}

// FORMATO DE FECHA
function formatearFecha(fechaISO: string) {
  const [anio, mes, dia] = fechaISO.split('-').map(Number);

  return new Intl.DateTimeFormat('es-SV', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  }).format(new Date(anio, mes - 1, dia));
}

// MOSTRAR ALERTAS
function mostrarAlerta(mensaje: string) {
  mensajeAlerta.value = mensaje;
  alertaAbierta.value = true;
}

// ENVIAR RESERVACIÓN A LARAVEL
async function enviarReserva() {

  // VERIFICAR HABITACIÓN
  if (!habitacionSeleccionada.value) {
    mostrarAlerta('Primero selecciona una habitación disponible.');
    return;
  }

  // VERIFICAR CAMPOS OBLIGATORIOS
  if (
    !reserva.nombre.trim() ||
    !reserva.dui.trim() ||
    !reserva.telefono.trim() ||
    !reserva.email.trim() ||
    !reserva.entrada ||
    !reserva.salida
  ) {
    mostrarAlerta(
      'Completa tu nombre, DUI, teléfono, correo electrónico y las fechas de entrada y salida.'
    );
    return;
  }

  // VALIDAR CORREO
  const patronEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (!patronEmail.test(reserva.email.trim())) {
    mostrarAlerta('Ingresa un correo electrónico válido.');
    return;
  }

  // VALIDAR DUI
  if (!/^\d{8}-\d$/.test(reserva.dui.trim())) {
    mostrarAlerta('Verifica el formato del DUI. Utiliza 00000000-0.');
    return;
  }

  // VALIDAR FECHAS
  if (reserva.salida <= reserva.entrada) {
    mostrarAlerta(
      'La fecha de salida debe ser posterior a la fecha de entrada.'
    );
    return;
  }

  // VALIDAR CAPACIDAD
  if (
    !Number.isInteger(reserva.personas) ||
    reserva.personas < 1 ||
    reserva.personas > Number(habitacionSeleccionada.value.capacidad)
  ) {
    mostrarAlerta(
      `La habitación permite un máximo de ${habitacionSeleccionada.value.capacidad} personas.`
    );
    return;
  }

  enviando.value = true;

  try {
    const respuesta = await fetch(`${API_URL}/reservas-publicas`, {
      method: 'POST',

      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },

      body: JSON.stringify({
        nombre: reserva.nombre.trim(),
        DUI: reserva.dui.trim(),
        telefono: reserva.telefono.trim(),
        email: reserva.email.trim(),
        id_habitacion: habitacionSeleccionada.value.id_habitacion,
        fecha_inicio: reserva.entrada,
        fecha_fin: reserva.salida
      })
    });

    const datos = await respuesta.json().catch(() => ({}));

    if (!respuesta.ok) {

      if (respuesta.status === 422) {
        const errores = datos.errors
          ? Object.values(datos.errors).flat().join(' ')
          : (datos.message || 'No fue posible registrar la reserva.');

        throw new Error(String(errores));
      }

      throw new Error(
        datos.message || 'No fue posible enviar la solicitud.'
      );
    }

    // GUARDAR DATOS PARA EL MENSAJE
    const nombreCliente = reserva.nombre.trim();

    const nombreHabitacion =
      `${habitacionSeleccionada.value.tipo} · ${habitacionSeleccionada.value.numero}`;

    // CERRAR FORMULARIO
    cerrarModal();

    // MOSTRAR CONFIRMACIÓN
    mostrarAlerta(
      `¡Gracias, ${nombreCliente}! Tu solicitud para ${nombreHabitacion} fue registrada correctamente. El equipo de AUREVANT revisará tu reservación.`
    );

    // ACTUALIZAR HABITACIONES
    await cargarHabitaciones();

  } catch (error) {

    mostrarAlerta(
      error instanceof Error
        ? error.message
        : 'Error de conexión con el servidor.'
    );

  } finally {
    enviando.value = false;
  }
}
</script>

<!-- ESTILOS GLOBALES DE LOS CUADROS EMERGENTES -->
<style>
ion-modal.reservation-modal,
ion-modal.calendar-modal {
  --backdrop-opacity: 0.38;
  --background: #f6f1e7;
  --ion-background-color: #f6f1e7;
  --ion-text-color: #202a24;
}

ion-modal.reservation-modal::part(content) {
  background: #f6f1e7;
}

ion-modal.calendar-modal::part(content) {
  background: #fffdf7;
}

ion-popover {
  --background: #fffdf7;
  --color: #0f3d2e;
  --width: min(320px, calc(100vw - 32px));
}

ion-alert {
  --background: #fffdf7;
  --color: #0f3d2e;
}

ion-alert .alert-wrapper {
  background: #fffdf7;
  color: #0f3d2e;
}
</style>

<style scoped>
.hotel-content {
  --background: #f6f1e7;
  --color: #202a24;
  font-family: Georgia, 'Times New Roman', serif;
}

/* PORTADA */
.hero {
  position: relative;
  height: 360px;
  min-height: 320px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: #0f3d2e;
}

.hero-image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(rgba(8, 25, 18, 0.35),
      rgba(8, 25, 18, 0.72));
}

.hero-content {
  position: relative;
  z-index: 2;
  color: #fffdf7;
  padding: 20px;
}

.eyebrow {
  color: #c7a66a;
  font-size: 11px;
  letter-spacing: 3px;
  font-weight: 600;
}

.hero h1 {
  font-size: 52px;
  font-weight: 400;
  margin: 14px 0;
}

.gold-line {
  width: 55px;
  height: 2px;
  background: #c7a66a;
  margin: 0 auto 16px;
}

.hero p {
  font-size: 16px;
  letter-spacing: 1px;
  color: #f6f1e7;
}

/* SECCIÓN DE HABITACIONES */
.rooms-section {
  padding: 55px 7%;
  background: #f6f1e7;
}

.section-title {
  text-align: center;
  margin-bottom: 35px;
}

.section-title h2,
.reservation-area h2 {
  color: #173e30;
  font-size: 32px;
  font-weight: 400;
  margin: 12px 0;
}

.section-title p,
.reservation-area p {
  color: #6c716a;
  font-family: Arial, sans-serif;
  font-size: 14px;
}

.rooms-message {
  margin: 18px 0 25px;
  padding: 22px;
  border: 1px solid #e3dac9;
  border-radius: 14px;
  background: #fffdf7;
  color: #405447;
  text-align: center;
  font-family: Arial, sans-serif;
}

.error-message {
  color: #9b342e;
}

/* TARJETAS DE HABITACIONES */
.room-card {
  display: grid;
  grid-template-columns: 1fr 1fr;
  background: #fffdf7;
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 25px;
  box-shadow: 0 8px 25px rgba(25, 45, 34, 0.08);
}

.room-card img {
  width: 100%;
  height: 100%;
  min-height: 280px;
  object-fit: cover;
}

.room-info {
  padding: 30px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.room-category {
  color: #b18b4e;
  font-size: 10px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.room-info h3 {
  color: #173e30;
  font-size: 25px;
  font-weight: 400;
  margin: 12px 0;
}

.room-info p {
  color: #73766e;
  font-family: Arial, sans-serif;
  font-size: 13px;
  line-height: 1.7;
}

.room-details {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin: 18px 0;
  color: #536257;
  font-family: Arial, sans-serif;
  font-size: 12px;
}

.room-details span {
  display: flex;
  align-items: center;
  gap: 6px;
}

.room-details ion-icon {
  color: #b18b4e;
  font-size: 17px;
}

.room-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-top: auto;
}

.price strong {
  color: #173e30;
  font-size: 23px;
}

.price span {
  color: #85877e;
  font-family: Arial, sans-serif;
  font-size: 12px;
}

.room-button {
  --background: #173e30;
  --background-hover: #285541;
  --color: #fffdf7;
  --border-radius: 5px;
  font-size: 12px;
  letter-spacing: 1px;
  text-transform: uppercase;
}

/* ÁREA DE RESERVACIÓN */
.reservation-area {
  margin-top: 55px;
  padding: 45px 25px;
  text-align: center;
  background: #173e30;
  border-radius: 15px;
}

.reservation-area h2 {
  color: #fffdf7;
}

.reservation-area p {
  color: #e4e0d5;
  margin-bottom: 25px;
}

.reserve-main-button {
  --background: #b18b4e;
  --background-hover: #98733e;
  --color: #fffdf7;
  --border-radius: 5px;
  --box-shadow: none;
  font-size: 13px;
  letter-spacing: 1px;
  text-transform: uppercase;
  margin-top: 15px;
}

/* MODAL DE RESERVACIÓN */
.modal-toolbar,
.calendar-toolbar {
  --background: #173e30;
  --color: #fffdf7;
}

.modal-content {
  --background: #f6f1e7;
}

.form-intro {
  padding: 25px 22px 10px;
  text-align: center;
}

.form-intro h2 {
  color: #173e30;
  font-size: 27px;
  font-weight: 400;
  margin: 12px 0;
}

.form-intro p {
  color: #77796f;
  font-family: Arial, sans-serif;
  font-size: 13px;
}

.reservation-form {
  padding: 15px 22px 30px;
}

.form-item {
  --background: #fffdf7;
  --border-color: #e3dac9;
  --highlight-color-focused: #b18b4e;
  --color: #173e30;
  margin: 10px 0;
  border-radius: 7px;
  font-family: Arial, sans-serif;
}

.form-item ion-input,
.form-item ion-select {
  --color: #173e30;
  --placeholder-color: #9a9a90;
  font-size: 14px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 12px;
}

/* FECHAS */
.date-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin: 18px 0;
}

.date-field {
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 13px 10px;
  border: 1px solid #e3dac9;
  border-radius: 8px;
  background: #fffdf7;
  color: #173e30;
  text-align: left;
}

.date-icon {
  color: #b18b4e;
  font-size: 19px;
}

.date-copy {
  display: flex;
  flex-direction: column;
  gap: 5px;
  min-width: 0;
}

.date-label {
  color: #85877e;
  font-family: Arial, sans-serif;
  font-size: 10px;
}

.date-copy strong {
  color: #173e30;
  font-size: 11px;
  font-weight: 600;
}

.date-chevron {
  margin-left: auto;
  color: #b18b4e;
}

/* BOTÓN CANCELAR */
.cancel-button {
  --color: #6e746b;
  font-size: 12px;
  letter-spacing: 1px;
}

/* CALENDARIO */
.calendar-content {
  --background: #fffdf7;
}

.calendar-hint {
  color: #6e746b;
  text-align: center;
  font-family: Arial, sans-serif;
  font-size: 13px;
  padding: 10px;
}

.aurevant-datetime {
  margin: 10px auto;
  --background: #fffdf7;
  --background-rgb: 255, 253, 247;
  --wheel-highlight-background: #f1eadc;
  --wheel-fade-background-rgb: 255, 253, 247;
  color: #173e30;
}

.calendar-actions {
  display: flex;
  justify-content: center;
  gap: 10px;
  padding: 15px;
}

.calendar-cancel {
  --color: #6e746b;
}

.calendar-accept {
  --background: #173e30;
  --color: #fffdf7;
  --border-radius: 5px;
}

/* DISEÑO RESPONSIVO */
@media (max-width: 650px) {
  .hero {
    height: 300px;
  }

  .hero h1 {
    font-size: 42px;
  }

  .rooms-section {
    padding: 40px 5%;
  }

  .section-title h2 {
    font-size: 27px;
  }

  .room-card {
    grid-template-columns: 1fr;
  }

  .room-card img {
    height: 220px;
    min-height: 220px;
  }

  .room-info {
    padding: 22px;
  }

  .room-info h3 {
    font-size: 22px;
  }

  .date-grid {
    grid-template-columns: 1fr;
  }
}
</style>