<template>
  <ion-page>
    <ion-content :fullscreen="true" class="restaurant-content">
      <main class="restaurant-page">

        <!-- HERO -->
        <section class="hero">
          <div class="hero-overlay"></div>

          <div class="hero-content">
            <span class="eyebrow">AUREVANT RESORT · GASTRONOMÍA</span>
            <h1>Una experiencia<br />para saborear</h1>
            <p>
              Sabores extraordinarios en un entorno donde la naturaleza
              y la elegancia se encuentran.
            </p>
            <button class="gold-button" @click="abrirMenu">
              DESCUBRIR MENÚ
            </button>
          </div>
        </section>

        <!-- ÁREAS DEL RESTAURANTE -->
        <section class="areas-section">
          <div class="section-heading">
            <span class="eyebrow">NUESTROS ESPACIOS</span>
            <h2>Elige tu ambiente ideal</h2>
            <p>Un espacio especial para cada ocasión.</p>
          </div>

          <div class="areas-grid">
            <article class="area-card">
              <img src="/images/chimenea.png" alt="Área de restaurante con chimenea" />
              <div class="area-info">
                <span>AMBIENTE CÁLIDO</span>
                <h3>Salón Chimenea</h3>
                <p>
                  Disfruta de una experiencia acogedora en un ambiente
                  elegante y relajante.
                </p>
                <button class="outline-button" @click="abrirReserva('chimenea')">
                  RESERVAR MESA
                </button>
              </div>
            </article>

            <article class="area-card">
              <img src="/images/terraza.png" alt="Terraza panorámica" />
              <div class="area-info">
                <span>VISTAS NATURALES</span>
                <h3>Terraza Panorámica</h3>
                <p>
                  Comparte momentos especiales mientras contemplas
                  el paisaje de las montañas.
                </p>
                <button class="outline-button" @click="abrirReserva('terraza')">
                  RESERVAR MESA
                </button>
              </div>
            </article>

            <article class="area-card">
              <img src="/images/ventanal.png" alt="Comedor con ventanales" />
              <div class="area-info">
                <span>VISTA PRIVILEGIADA</span>
                <h3>Salón Ventanal</h3>
                <p>
                  Un ambiente sofisticado con amplios ventanales
                  y conexión con la naturaleza.
                </p>
                <button class="outline-button" @click="abrirReserva('ventanal')">
                  RESERVAR MESA
                </button>
              </div>
            </article>
          </div>
        </section>

        <!-- INVITACIÓN A RESERVAR -->
        <section class="reservation-banner">
          <div>
            <span class="eyebrow">TU MESA TE ESPERA</span>
            <h2>Haz de tu visita un momento inolvidable</h2>
            <p>Reserva tu espacio y disfruta de AUREVANT.</p>
          </div>

          <button class="gold-button" @click="abrirReserva('')">
            RESERVAR AHORA
          </button>
        </section>

        <!-- MODAL DEL MENÚ -->
        <ion-modal :is-open="mostrarMenu" @didDismiss="cerrarMenu" class="menu-modal">
          <ion-header>
            <ion-toolbar class="modal-toolbar">
              <ion-title>Menú gastronómico</ion-title>
              <ion-buttons slot="end">
                <ion-button @click="cerrarMenu">
                  <ion-icon :icon="closeOutline" />
                </ion-button>
              </ion-buttons>
            </ion-toolbar>
          </ion-header>

          <ion-content class="modal-content">
            <div class="modal-intro">
              <span class="eyebrow">AUREVANT RESORT</span>
              <h2>Sabores para recordar</h2>
              <p>Descubre nuestra propuesta gastronómica.</p>
            </div>

            <div v-if="cargandoPlatillos" class="menu-message">
              <ion-spinner name="crescent"></ion-spinner>
              <p>Cargando nuestro menú...</p>
            </div>

            <div v-else-if="errorPlatillos" class="menu-message">
              <p>{{ errorPlatillos }}</p>
              <ion-button fill="outline" class="retry-button" @click="cargarPlatillos">
                INTENTAR NUEVAMENTE
              </ion-button>
            </div>

            <div v-else-if="platillos.length === 0" class="menu-message">
              <p>Próximamente tendremos deliciosas opciones para ti.</p>
            </div>

            <div v-else class="platillos-grid">
              <article v-for="platillo in platillos" :key="platillo.id_platillo" class="platillo-card">
                <img :src="obtenerImagen(platillo.img)" :alt="platillo.nombre" @error="imagenError" />

                <div class="platillo-info">
                  <span class="platillo-categoria">
                    {{ platillo.categoria || 'Especialidad de la casa' }}
                  </span>

                  <h3>{{ platillo.nombre }}</h3>

                  <p>
                    {{ platillo.descripcion || 'Una deliciosa opción de nuestra cocina.' }}
                  </p>

                  <p v-if="platillo.ingredientes" class="platillo-ingredientes">
                    {{ platillo.ingredientes }}
                  </p>

                  <strong class="platillo-precio">
                    ${{ Number(platillo.precio).toFixed(2) }}
                  </strong>
                </div>
              </article>
            </div>
          </ion-content>
        </ion-modal>

        <!-- MODAL DE RESERVACIÓN -->
        <ion-modal :is-open="mostrarReserva" @didDismiss="cerrarReserva" class="reservation-modal">
          <ion-header>
            <ion-toolbar class="modal-toolbar">
              <ion-title>Reservación de mesa</ion-title>
              <ion-buttons slot="end">
                <ion-button @click="cerrarReserva" :disabled="guardandoReserva">
                  <ion-icon :icon="closeOutline" />
                </ion-button>
              </ion-buttons>
            </ion-toolbar>
          </ion-header>

          <ion-content class="modal-content">
            <div class="modal-intro">
              <span class="eyebrow">AUREVANT RESORT</span>
              <h2>Reserva tu mesa</h2>
              <p>Completa tus datos para solicitar tu reservación.</p>
            </div>

            <form class="reservation-form" @submit.prevent="guardarReserva">

              <!-- NOMBRE -->
              <ion-item class="form-item">
                <ion-input v-model.trim="reserva.nombre" label="Nombre completo" label-placement="stacked"
                  placeholder="Escribe tu nombre" :maxlength="100" required />
              </ion-item>

              <!-- DUI -->
              <ion-item class="form-item">
                <ion-input v-model.trim="reserva.dui" label="DUI" label-placement="stacked" placeholder="Ej. 00000000-0"
                  :maxlength="10" required />
              </ion-item>

              <p class="field-hint">
                Escribe tu DUI con el formato 00000000-0.
              </p>

              <!-- TELÉFONO -->
              <ion-item class="form-item">
                <ion-input v-model.trim="reserva.telefono" label="Teléfono" label-placement="stacked" type="tel"
                  placeholder="Número de teléfono" :maxlength="20" required />
              </ion-item>

              <!-- ÁREA -->
              <ion-item class="form-item">
                <ion-select v-model="areaSeleccionada" label="Área del restaurante" label-placement="stacked"
                  placeholder="Selecciona un área" interface="popover" @ionChange="actualizarMesas">
                  <ion-select-option value="">Todas las áreas</ion-select-option>
                  <ion-select-option value="chimenea">Salón Chimenea</ion-select-option>
                  <ion-select-option value="terraza">Terraza Panorámica</ion-select-option>
                  <ion-select-option value="ventanal">Salón Ventanal</ion-select-option>
                </ion-select>
              </ion-item>

              <!-- MESA DISPONIBLE -->
              <ion-item class="form-item">
                <ion-select v-model="reserva.id_mesa" label="Mesa disponible" label-placement="stacked"
                  placeholder="Selecciona una mesa" interface="popover"
                  :disabled="cargandoMesas || mesasFiltradas.length === 0" required>
                  <ion-select-option v-for="mesa in mesasFiltradas" :key="mesa.id_mesa" :value="mesa.id_mesa">
                    Mesa {{ mesa.id_mesa }} ·
                    {{ mesa.capacidad }} personas ·
                    {{ nombreAmbiente(mesa.ambiente) }}
                  </ion-select-option>
                </ion-select>
              </ion-item>

              <div v-if="cargandoMesas" class="loading-mesas">
                <ion-spinner name="crescent"></ion-spinner>
                <span>Consultando mesas disponibles...</span>
              </div>

              <p v-if="errorMesas" class="field-error">
                {{ errorMesas }}
              </p>

              <p v-else-if="!cargandoMesas && mesasFiltradas.length === 0" class="field-hint">
                No hay mesas disponibles para esta área.
              </p>

              <!-- PERSONAS -->
              <ion-item class="form-item">
                <ion-input v-model.number="reserva.personas" label="Cantidad de personas" label-placement="stacked"
                  type="number" min="1" max="20" required />
              </ion-item>

              <!-- FECHA Y HORA CON SELECTORES -->
              <div class="date-grid">

                <button type="button" class="date-field" @click="abrirSelector('fecha')">
                  <span class="date-icon">
                    <ion-icon :icon="calendarOutline" />
                  </span>

                  <span class="date-copy">
                    <span class="date-label">Fecha de reservación</span>
                    <strong>
                      {{ reserva.fecha ? formatearFecha(reserva.fecha) : 'Seleccionar fecha' }}
                    </strong>
                  </span>

                  <ion-icon class="date-chevron" :icon="chevronDownOutline" />
                </button>

                <button type="button" class="date-field" @click="abrirSelector('hora')">
                  <span class="date-icon">
                    <ion-icon :icon="timeOutline" />
                  </span>

                  <span class="date-copy">
                    <span class="date-label">Hora de reservación</span>
                    <strong>
                      {{ reserva.hora || 'Seleccionar hora' }}
                    </strong>
                  </span>

                  <ion-icon class="date-chevron" :icon="chevronDownOutline" />
                </button>

              </div>

              <!-- ERROR DE RESERVACIÓN -->
              <p v-if="errorReserva" class="form-error">
                {{ errorReserva }}
              </p>

              <!-- CONFIRMAR -->
              <ion-button type="submit" expand="block" class="reserve-main-button"
                :disabled="guardandoReserva || cargandoMesas">
                <ion-spinner v-if="guardandoReserva" name="crescent" />
                <span v-else>CONFIRMAR SOLICITUD</span>
              </ion-button>

              <!-- CANCELAR -->
              <ion-button type="button" expand="block" fill="clear" class="cancel-button" @click="cerrarReserva"
                :disabled="guardandoReserva">
                CANCELAR
              </ion-button>
            </form>
          </ion-content>
        </ion-modal>

        <!-- MODAL DE CALENDARIO Y HORA -->
        <ion-modal :is-open="selectorAbierto" @didDismiss="cerrarSelector" class="calendar-modal">
          <ion-header>
            <ion-toolbar class="calendar-toolbar">
              <ion-title>
                {{ selectorObjetivo === 'fecha'
                  ? 'Fecha de reservación'
                  : 'Hora de reservación' }}
              </ion-title>

              <ion-buttons slot="end">
                <ion-button @click="cerrarSelector">
                  <ion-icon :icon="closeOutline" />
                </ion-button>
              </ion-buttons>
            </ion-toolbar>
          </ion-header>

          <ion-content class="calendar-content">
            <p class="calendar-hint">
              {{ selectorObjetivo === 'fecha'
                ? 'Selecciona el día de tu reservación.'
                : 'Selecciona la hora de tu reservación.' }}
            </p>

            <ion-datetime v-model="valorTemporal" :presentation="selectorObjetivo === 'fecha' ? 'date' : 'time'"
              :min="selectorObjetivo === 'fecha' ? hoy : undefined" :first-day-of-week="1" locale="es-SV"
              hour-cycle="h23" :show-default-buttons="false" class="aurevant-datetime" />

            <div class="calendar-actions">
              <ion-button fill="clear" class="calendar-cancel" @click="cerrarSelector">
                Cancelar
              </ion-button>

              <ion-button class="calendar-accept" @click="confirmarSelector">
                Confirmar
              </ion-button>
            </div>
          </ion-content>
        </ion-modal>

        <!-- ALERTA DE CONFIRMACIÓN -->
        <ion-alert :is-open="mostrarConfirmacion" header="AUREVANT RESORT" sub-header="¡Solicitud recibida!"
          message="Tu solicitud de reservación fue registrada correctamente. Nuestro equipo podrá dar seguimiento a tu solicitud."
          :buttons="[{ text: 'ACEPTAR', role: 'confirm' }]" @didDismiss="cerrarConfirmacion" />

        <!-- FOOTER -->
        <footer class="restaurant-footer">
          <h2>AUREVANT</h2>
          <span>EL LUJO ENCUENTRA SU ALTURA</span>
          <p>Una experiencia para disfrutar y recordar.</p>
        </footer>

      </main>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue';

import {
  IonPage,
  IonContent,
  IonSpinner,
  IonModal,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonButtons,
  IonButton,
  IonIcon,
  IonItem,
  IonInput,
  IonSelect,
  IonSelectOption,
  IonAlert,
  IonDatetime
} from '@ionic/vue';

import {
  closeOutline,
  calendarOutline,
  timeOutline,
  chevronDownOutline
} from 'ionicons/icons';

const API_URL = 'http://127.0.0.1:8000/api';

// ======================================
// INTERFACES
// ======================================

interface Platillo {
  id_platillo: number;
  nombre: string;
  descripcion: string | null;
  precio: number | string;
  categoria: string;
  tipo: string;
  ingredientes: string | null;
  img: string | null;
  activo: boolean | number;
}

interface Mesa {
  id_mesa: number;
  capacidad: number;
  ambiente: string;
  estado: string;
}

interface Reserva {
  id_mesa: number | '';
  nombre: string;
  dui: string;
  telefono: string;
  fecha: string;
  hora: string;
  personas: number;
}

type TipoSelector = 'fecha' | 'hora';

// ======================================
// MENÚ DEL RESTAURANTE
// ======================================

const platillos = ref<Platillo[]>([]);
const cargandoPlatillos = ref(false);
const errorPlatillos = ref('');
const mostrarMenu = ref(false);

async function cargarPlatillos() {
  cargandoPlatillos.value = true;
  errorPlatillos.value = '';

  try {
    const respuesta = await fetch(`${API_URL}/platillos-publicos`, {
      method: 'GET',
      headers: { Accept: 'application/json' }
    });

    if (!respuesta.ok) {
      throw new Error('No fue posible cargar los platillos.');
    }

    const datos: Platillo[] = await respuesta.json();

    platillos.value = datos.filter(
      producto => producto.tipo === 'platillo'
    );

  } catch (error) {
    console.error('Error al cargar platillos:', error);
    errorPlatillos.value =
      'No se pudo cargar el menú. Verifica que Laravel esté funcionando.';

  } finally {
    cargandoPlatillos.value = false;
  }
}

function abrirMenu() {
  mostrarMenu.value = true;

  if (platillos.value.length === 0 && !cargandoPlatillos.value) {
    cargarPlatillos();
  }
}

function cerrarMenu() {
  mostrarMenu.value = false;
}

function obtenerImagen(imagen: string | null): string {
  if (!imagen) {
    return '/images/platillo-default.jpg';
  }

  if (
    imagen.startsWith('http://') ||
    imagen.startsWith('https://') ||
    imagen.startsWith('data:')
  ) {
    return imagen;
  }

  const ruta = imagen.startsWith('/') ? imagen : `/${imagen}`;

  return `http://127.0.0.1:8000${ruta}`;
}

function imagenError(event: Event) {
  const elemento = event.target as HTMLImageElement;
  elemento.src = '/images/platillo-default.jpg';
}

// ======================================
// RESERVACIÓN DE MESAS
// ======================================

const mesas = ref<Mesa[]>([]);
const cargandoMesas = ref(false);
const errorMesas = ref('');

const mostrarReserva = ref(false);
const mostrarConfirmacion = ref(false);
const guardandoReserva = ref(false);
const errorReserva = ref('');

const areaSeleccionada = ref('');

const reserva = reactive<Reserva>({
  id_mesa: '',
  nombre: '',
  dui: '',
  telefono: '',
  fecha: '',
  hora: '',
  personas: 2
});

// ======================================
// CALENDARIO Y SELECTOR DE HORA
// ======================================

const selectorAbierto = ref(false);
const selectorObjetivo = ref<TipoSelector>('fecha');
const valorTemporal = ref('');

const hoy = computed(() => {
  const fecha = new Date();

  const anio = fecha.getFullYear();
  const mes = String(fecha.getMonth() + 1).padStart(2, '0');
  const dia = String(fecha.getDate()).padStart(2, '0');

  return `${anio}-${mes}-${dia}`;
});

// ABRIR SELECTOR
function abrirSelector(tipo: TipoSelector) {
  selectorObjetivo.value = tipo;

  if (tipo === 'fecha') {
    valorTemporal.value = reserva.fecha || hoy.value;
  } else {
    valorTemporal.value =
      `2000-01-01T${reserva.hora || '12:00'}:00`;
  }

  selectorAbierto.value = true;
}

// CERRAR SELECTOR
function cerrarSelector() {
  selectorAbierto.value = false;
}

// CONFIRMAR FECHA U HORA
function confirmarSelector() {
  if (!valorTemporal.value) {
    cerrarSelector();
    return;
  }

  if (selectorObjetivo.value === 'fecha') {
    const fechaSeleccionada = valorTemporal.value.substring(0, 10);

    if (fechaSeleccionada < hoy.value) {
      errorReserva.value = 'No puedes seleccionar una fecha anterior a hoy.';
      cerrarSelector();
      return;
    }

    reserva.fecha = fechaSeleccionada;

  } else {
    const valorHora = valorTemporal.value;

    reserva.hora = valorHora.includes('T')
      ? valorHora.split('T')[1].substring(0, 5)
      : valorHora.substring(0, 5);
  }

  errorReserva.value = '';
  cerrarSelector();
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

// ======================================
// FECHA MÍNIMA
// ======================================

const fechaMinima = computed(() => hoy.value);

// ======================================
// FILTRAR MESAS DISPONIBLES
// ======================================

const mesasFiltradas = computed(() => {
  return mesas.value.filter(mesa => {
    const disponible =
      String(mesa.estado).toLowerCase() === 'disponible';

    const coincideArea =
      !areaSeleccionada.value ||
      String(mesa.ambiente).toLowerCase() ===
      areaSeleccionada.value.toLowerCase();

    return disponible && coincideArea;
  });
});

// ======================================
// NOMBRE DEL AMBIENTE
// ======================================

function nombreAmbiente(ambiente: string): string {
  const nombres: Record<string, string> = {
    chimenea: 'Salón Chimenea',
    terraza: 'Terraza Panorámica',
    ventanal: 'Salón Ventanal'
  };

  return nombres[ambiente?.toLowerCase()] || ambiente;
}

// ======================================
// CONSULTAR MESAS EN LARAVEL
// ======================================

async function cargarMesas() {
  cargandoMesas.value = true;
  errorMesas.value = '';

  try {
    const respuesta = await fetch(`${API_URL}/mesas-publicas`, {
      method: 'GET',
      headers: { Accept: 'application/json' }
    });

    if (!respuesta.ok) {
      throw new Error('No fue posible consultar las mesas.');
    }

    mesas.value = await respuesta.json();

  } catch (error) {
    console.error('Error al cargar mesas:', error);

    errorMesas.value =
      'No se pudieron consultar las mesas. Verifica que Laravel esté funcionando.';

  } finally {
    cargandoMesas.value = false;
  }
}

// ======================================
// ACTUALIZAR MESAS SEGÚN EL ÁREA
// ======================================

function actualizarMesas() {
  reserva.id_mesa = '';
}

// ======================================
// ABRIR RESERVACIÓN
// ======================================

function abrirReserva(area: string) {
  areaSeleccionada.value = area;

  reserva.id_mesa = '';
  reserva.nombre = '';
  reserva.dui = '';
  reserva.telefono = '';
  reserva.fecha = '';
  reserva.hora = '';
  reserva.personas = 2;

  selectorAbierto.value = false;
  valorTemporal.value = '';

  errorReserva.value = '';
  errorMesas.value = '';

  mostrarReserva.value = true;

  cargarMesas();
}

// ======================================
// CERRAR RESERVACIÓN
// ======================================

function cerrarReserva() {
  if (guardandoReserva.value) return;

  mostrarReserva.value = false;
  selectorAbierto.value = false;
  errorReserva.value = '';
}

// ======================================
// GUARDAR RESERVACIÓN EN LARAVEL
// ======================================

async function guardarReserva() {
  errorReserva.value = '';

  if (!reserva.id_mesa) {
    errorReserva.value = 'Debes seleccionar una mesa.';
    return;
  }

  if (!reserva.nombre.trim()) {
    errorReserva.value = 'Debes ingresar tu nombre completo.';
    return;
  }

  if (!/^[0-9]{8}-[0-9]$/.test(reserva.dui)) {
    errorReserva.value = 'El DUI debe tener el formato 00000000-0.';
    return;
  }

  if (!reserva.telefono.trim()) {
    errorReserva.value = 'Debes ingresar tu teléfono.';
    return;
  }

  if (!reserva.fecha) {
    errorReserva.value = 'Debes seleccionar una fecha.';
    return;
  }

  if (reserva.fecha < hoy.value) {
    errorReserva.value = 'No puedes reservar en una fecha anterior a hoy.';
    return;
  }

  if (!reserva.hora) {
    errorReserva.value = 'Debes seleccionar una hora.';
    return;
  }

  if (
    !Number.isInteger(reserva.personas) ||
    reserva.personas < 1 ||
    reserva.personas > 20
  ) {
    errorReserva.value =
      'La cantidad de personas debe estar entre 1 y 20.';
    return;
  }

  guardandoReserva.value = true;

  try {
    const horaConSegundos =
      reserva.hora.length === 5
        ? `${reserva.hora}:00`
        : reserva.hora;

    const datosReserva = {
      id_mesa: reserva.id_mesa,
      nombre: reserva.nombre,
      dui: reserva.dui,
      telefono: reserva.telefono,
      fecha: reserva.fecha,
      hora: horaConSegundos,
      personas: reserva.personas
    };

    const respuesta = await fetch(
      `${API_URL}/reserva-mesas-publica`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json'
        },
        body: JSON.stringify(datosReserva)
      }
    );

    const datos = await respuesta.json().catch(() => ({}));

    if (!respuesta.ok) {
      if (datos.errors) {
        const primerError = Object.values(datos.errors)
          .flat()
          .find(error => typeof error === 'string');

        throw new Error(
          primerError ||
          datos.message ||
          'No se pudo registrar la reservación.'
        );
      }

      throw new Error(
        datos.message || 'No se pudo registrar la reservación.'
      );
    }

    // CERRAR FORMULARIO
    mostrarReserva.value = false;
    selectorAbierto.value = false;

    // MOSTRAR CONFIRMACIÓN
    mostrarConfirmacion.value = true;

    // LIMPIAR FORMULARIO
    reserva.id_mesa = '';
    reserva.nombre = '';
    reserva.dui = '';
    reserva.telefono = '';
    reserva.fecha = '';
    reserva.hora = '';
    reserva.personas = 2;

    areaSeleccionada.value = '';

    // ACTUALIZAR MESAS
    await cargarMesas();

  } catch (error) {
    console.error('Error al guardar reservación:', error);

    errorReserva.value =
      error instanceof Error
        ? error.message
        : 'Ocurrió un error al procesar la reservación.';

  } finally {
    guardandoReserva.value = false;
  }
}

// ======================================
// CERRAR CONFIRMACIÓN
// ======================================

function cerrarConfirmacion() {
  mostrarConfirmacion.value = false;
}

// ======================================
// CARGA INICIAL
// ======================================

onMounted(() => {
  cargarPlatillos();
  cargarMesas();
});
</script>

<!-- ESTILOS GLOBALES PARA LOS ELEMENTOS INTERNOS DE IONIC -->
<style>
ion-modal.menu-modal,
ion-modal.reservation-modal,
ion-modal.calendar-modal {
  --backdrop-opacity: .45;
  --background: #f6f1e7;
  --ion-background-color: #f6f1e7;
  --ion-text-color: #202820;

  --width: 100%;
  --height: 90%;
  --max-width: 850px;
  --max-height: 900px;
  --border-radius: 12px;
}

ion-modal.reservation-modal {
  --max-width: 600px;
}

ion-modal.calendar-modal {
  --max-width: 420px;
  --height: auto;
  --max-height: 650px;
  --background: #fffdf8;
  --ion-background-color: #fffdf8;
}

ion-modal.menu-modal::part(content),
ion-modal.reservation-modal::part(content),
ion-modal.calendar-modal::part(content) {
  background: #f6f1e7;
  border: 1px solid #d4b483;
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, .25);
}

ion-modal.calendar-modal::part(content) {
  background: #fffdf8;
}

ion-alert {
  --background: #fffdf8;
  --color: #183d2e;
}

ion-alert .alert-wrapper {
  background: #fffdf8;
  color: #183d2e;
  border: 1px solid #d4b483;
  border-radius: 10px;
}

ion-alert .alert-head h2 {
  color: #183d2e;
  font-family: Georgia, 'Times New Roman', serif;
}

ion-alert .alert-sub-title {
  color: #a98750;
}

ion-alert .alert-message {
  color: #77776e;
  line-height: 1.7;
}

ion-alert .alert-button {
  color: #a98750;
  font-weight: 700;
}

ion-popover {
  --background: #fffdf8;
  --color: #183d2e;
  --width: min(320px, calc(100vw - 32px));
}

ion-popover::part(content) {
  border: 1px solid #e3dac9;
  border-radius: 8px;
}
</style>

<style scoped>
/* ======================================
   AUREVANT RESORT - PALETA DE COLORES
====================================== */

.restaurant-page {
  --verde-bosque: #183d2e;
  --verde-profundo: #102b21;
  --dorado: #d4b483;
  --dorado-oscuro: #a98750;
  --crema: #f6f1e7;
  --blanco-crema: #fffdf8;
  --texto: #202820;
  --texto-suave: #77776e;

  background: var(--crema);
  color: var(--texto);
  min-height: 100%;
  font-family: Arial, Helvetica, sans-serif;
}

.restaurant-content {
  --background: #f6f1e7;
  --color: #202820;
}

.eyebrow {
  display: inline-block;
  color: var(--dorado);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 3px;
}

/* HERO */

.hero {
  position: relative;
  min-height: 590px;
  display: flex;
  align-items: center;
  padding: 70px 9%;
  background-image: url('/images/restaurante-hero.png');
  background-position: center;
  background-size: cover;
  color: #fff;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg,
      rgba(12, 30, 22, .88),
      rgba(12, 30, 22, .45),
      rgba(12, 30, 22, .10));
}

.hero-content {
  position: relative;
  z-index: 1;
  max-width: 600px;
}

.hero h1 {
  margin: 22px 0;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: clamp(42px, 6vw, 70px);
  line-height: 1.08;
  font-weight: 400;
}

.hero p {
  max-width: 480px;
  color: #eee9df;
  font-size: 16px;
  line-height: 1.8;
  margin-bottom: 30px;
}

/* BOTONES */

.gold-button {
  border: 1px solid var(--dorado);
  background: var(--dorado);
  color: var(--verde-bosque);
  padding: 15px 27px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.7px;
  cursor: pointer;
  transition: .25s ease;
}

.gold-button:hover {
  background: #e5c99c;
  transform: translateY(-2px);
}

.outline-button {
  border: 1px solid var(--dorado-oscuro);
  background: transparent;
  color: var(--verde-bosque);
  padding: 12px 20px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1px;
  cursor: pointer;
  transition: .25s ease;
}

.outline-button:hover {
  background: var(--verde-bosque);
  color: #fff;
}

/* ENCABEZADOS */

.section-heading h2 {
  margin: 18px 0;
  color: var(--verde-bosque);
  font-family: Georgia, 'Times New Roman', serif;
  font-size: clamp(30px, 4vw, 43px);
  font-weight: 400;
}

.section-heading p {
  color: var(--texto-suave);
  font-size: 15px;
  line-height: 1.9;
}

/* ÁREAS */

.areas-section {
  padding: 70px 7% 100px;
  background: var(--blanco-crema);
}

.section-heading {
  text-align: center;
  margin-bottom: 45px;
}

.areas-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 25px;
  max-width: 1250px;
  margin: auto;
}

.area-card {
  background: var(--crema);
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, .07);
  transition: .3s ease;
}

.area-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 14px 30px rgba(0, 0, 0, .12);
}

.area-card img {
  width: 100%;
  height: 250px;
  display: block;
  object-fit: cover;
}

.area-info {
  padding: 27px;
}

.area-info>span {
  color: var(--dorado-oscuro);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.7px;
}

.area-info h3 {
  margin: 12px 0;
  color: var(--verde-bosque);
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 25px;
  font-weight: 400;
}

.area-info p {
  min-height: 75px;
  color: var(--texto-suave);
  font-size: 13px;
  line-height: 1.8;
}

/* BANNER DE RESERVACIÓN */

.reservation-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 30px;
  padding: 75px 9%;
  background: var(--verde-bosque);
  color: #fff;
}

.reservation-banner h2 {
  max-width: 650px;
  margin: 15px 0;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: clamp(27px, 4vw, 40px);
  font-weight: 400;
}

.reservation-banner p {
  color: #d8d9d0;
  line-height: 1.7;
}

/* MODALES */

.modal-toolbar,
.calendar-toolbar {
  --background: #183d2e;
  --color: #fffdf8;
}

.modal-toolbar ion-title,
.calendar-toolbar ion-title {
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 18px;
  font-weight: 400;
  letter-spacing: .5px;
}

.modal-toolbar ion-button,
.calendar-toolbar ion-button {
  --color: #d4b483;
}

.modal-content {
  --background: #f6f1e7;
  --color: #202820;
}

.modal-intro {
  padding: 28px 22px 15px;
  text-align: center;
}

.modal-intro .eyebrow {
  color: #a98750;
}

.modal-intro h2 {
  margin: 13px 0;
  color: #183d2e;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 29px;
  font-weight: 400;
}

.modal-intro p {
  color: #77776e;
  font-size: 13px;
  line-height: 1.8;
}

/* MENSAJES DEL MENÚ */

.menu-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  min-height: 180px;
  padding: 20px;
  color: #77776e;
  text-align: center;
}

.menu-message ion-spinner {
  color: #b18b4e;
  width: 35px;
  height: 35px;
}

.retry-button {
  --color: #183d2e;
  --border-color: #b18b4e;
  font-size: 11px;
  letter-spacing: 1px;
}

/* PLATILLOS */

.platillos-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px;
  padding: 15px 22px 30px;
}

.platillo-card {
  overflow: hidden;
  background: #fffdf8;
  border: 1px solid #e3dac9;
  border-radius: 8px;
  box-shadow: 0 6px 18px rgba(25, 45, 34, .06);
  transition: .3s ease;
}

.platillo-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 25px rgba(0, 0, 0, .12);
}

.platillo-card img {
  display: block;
  width: 100%;
  height: 190px;
  object-fit: cover;
  background: #e9e3d7;
}

.platillo-info {
  padding: 20px;
}

.platillo-categoria {
  color: #a98750;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.platillo-info h3 {
  margin: 10px 0;
  color: #183d2e;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 21px;
  font-weight: 400;
}

.platillo-info p {
  color: #77776e;
  font-size: 12px;
  line-height: 1.7;
}

.platillo-info .platillo-ingredientes {
  color: #888477;
  font-size: 11px;
  font-style: italic;
}

.platillo-precio {
  display: block;
  margin-top: 15px;
  color: #183d2e;
  font-size: 19px;
  font-weight: 700;
}

/* FORMULARIO */

.reservation-form {
  display: flex;
  flex-direction: column;
  gap: 11px;
  padding: 10px 22px 30px;
}

.form-item {
  --background: #fffdf8;
  --border-color: #e3dac9;
  --highlight-color-focused: #b18b4e;
  --color: #183d2e;

  margin: 7px 0;
  border: 1px solid #e3dac9;
  border-radius: 8px;
  font-family: Arial, Helvetica, sans-serif;
}

.form-item ion-input,
.form-item ion-select {
  --color: #183d2e;
  --placeholder-color: #929287;
  --highlight-color-focused: #b18b4e;
  font-size: 14px;
}

.form-item ion-select {
  width: 100%;
  max-width: 100%;
}

.form-item ion-input::part(label),
.form-item ion-select::part(label) {
  color: #a98750;
  font-size: 12px;
  font-weight: 600;
}

.field-hint {
  margin: -5px 5px 3px;
  color: #77776e;
  font-size: 11px;
  line-height: 1.5;
}

.field-error,
.form-error {
  margin: 5px;
  color: #a33a32;
  font-size: 12px;
  line-height: 1.5;
}

.loading-mesas {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 5px;
  color: #77776e;
  font-size: 12px;
}

.loading-mesas ion-spinner {
  color: #b18b4e;
}

/* FECHA Y HORA */

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
  background: #fffdf8;
  color: #183d2e;
  text-align: left;
  cursor: pointer;
  transition: .2s ease;
}

.date-field:hover {
  border-color: #b18b4e;
  background: #fdf9ef;
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
  color: #183d2e;
  font-size: 11px;
  font-weight: 600;
}

.date-chevron {
  margin-left: auto;
  color: #b18b4e;
}

/* CALENDARIO Y HORA */

.calendar-content {
  --background: #fffdf8;
}

.calendar-hint {
  color: #6e746b;
  text-align: center;
  font-family: Arial, sans-serif;
  font-size: 13px;
  padding: 10px;
}

.aurevant-datetime {
  display: block;
  margin: 10px auto;
  --background: #fffdf8;
  --background-rgb: 255, 253, 248;
  --wheel-highlight-background: #f1eadc;
  --wheel-fade-background-rgb: 255, 253, 248;
  --ion-color-primary: #183d2e;
  color: #183d2e;
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
  --background: #183d2e;
  --color: #fffdf8;
  --border-radius: 5px;
}

/* BOTONES DEL FORMULARIO */

.reserve-main-button {
  --background: #183d2e;
  --background-hover: #285541;
  --color: #fffdf8;
  --border-radius: 6px;
  --box-shadow: none;

  height: 48px;
  margin-top: 15px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.2px;
}

.reserve-main-button ion-spinner {
  width: 20px;
  height: 20px;
  color: #fffdf8;
}

.cancel-button {
  --color: #6e746b;
  font-size: 11px;
  letter-spacing: 1px;
}

/* FOOTER */

.restaurant-footer {
  padding: 55px 20px;
  background: var(--verde-profundo);
  color: #fff;
  text-align: center;
}

.restaurant-footer h2 {
  margin: 0 0 8px;
  color: var(--dorado);
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 30px;
  font-weight: 400;
  letter-spacing: 5px;
}

.restaurant-footer span {
  color: var(--dorado);
  font-size: 9px;
  letter-spacing: 2px;
}

.restaurant-footer p {
  margin-top: 18px;
  color: #d8d9d0;
  font-size: 12px;
}

/* RESPONSIVE */

@media (max-width: 850px) {
  .areas-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .reservation-banner {
    align-items: flex-start;
    flex-direction: column;
  }
}

@media (max-width: 600px) {
  .hero {
    min-height: 520px;
    padding: 55px 25px;
  }

  .hero h1 {
    font-size: 43px;
  }

  .areas-section {
    padding: 60px 20px;
  }

  .areas-grid {
    grid-template-columns: 1fr;
  }

  .area-card img {
    height: 220px;
  }

  .reservation-banner {
    padding: 55px 25px;
  }

  .platillos-grid {
    grid-template-columns: 1fr;
    padding: 12px 16px 25px;
  }

  .platillo-card {
    display: grid;
    grid-template-columns: 40% 60%;
  }

  .platillo-card img {
    height: 100%;
    min-height: 175px;
  }

  .platillo-info {
    padding: 13px;
  }

  .platillo-info h3 {
    font-size: 18px;
  }

  .platillo-info p {
    font-size: 11px;
  }

  .date-grid {
    grid-template-columns: 1fr;
  }

  .modal-intro h2 {
    font-size: 26px;
  }

  .reservation-form {
    padding: 10px 16px 25px;
  }
}
</style>
