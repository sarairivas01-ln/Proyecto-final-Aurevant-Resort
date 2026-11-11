<template>
    <ion-page class="bar-page">
        <ion-content :fullscreen="true" class="bar-content">

            <!-- PORTADA -->
            <section class="hero">
                <img class="hero-image"
                    src="https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=1800&q=90"
                    alt="Bar elegante de AUREVANT Resort" />

                <div class="hero-overlay"></div>

                <div class="hero-content">
                    <span class="eyebrow">AUREVANT RESORT</span>
                    <h1>Bar</h1>
                    <div class="gold-line"></div>
                    <p>El arte de disfrutar cada momento</p>
                </div>
            </section>

            <!-- PRESENTACIÓN -->
            <section class="intro section">
                <span class="section-label">UN ESPACIO EXCLUSIVO</span>

                <h2>Momentos que<br />merecen celebrarse</h2>

                <p>
                    Descubre una experiencia única entre montañas, con bebidas
                    cuidadosamente seleccionadas, sabores especiales y un ambiente
                    diseñado para relajarte y disfrutar.
                </p>
            </section>

            <!-- EXPERIENCIA -->
            <section class="experience">
                <img src="https://images.unsplash.com/photo-1470337458703-46ad1756a187?auto=format&fit=crop&w=1200&q=85"
                    alt="Cócteles preparados por nuestros bartenders" />

                <div class="experience-text">
                    <span class="section-label">NUESTRA ESENCIA</span>

                    <h2>El placer está en los detalles</h2>

                    <p>
                        Desde cócteles artesanales hasta bebidas clásicas, cada elección
                        está pensada para acompañar tus mejores momentos.
                    </p>
                </div>
            </section>

            <!-- SELECCIÓN DE BEBIDAS -->
            <section class="section drinks-section">

                <div class="section-heading">
                    <span class="section-label">DESCUBRE NUESTRA SELECCIÓN</span>

                    <h2>Nuestras bebidas</h2>

                    <p class="drinks-description">
                        Explora nuestra selección y encuentra tu bebida favorita.
                    </p>
                </div>

                <!-- CARGANDO -->
                <div v-if="cargandoBebidas" class="loading-container">
                    <ion-spinner name="crescent"></ion-spinner>
                    <p>Cargando nuestra selección...</p>
                </div>

                <!-- ERROR -->
                <div v-else-if="errorBebidas" class="message-container">
                    <p>{{ errorBebidas }}</p>

                    <button class="retry-button" @click="cargarBebidas">
                        Intentar nuevamente
                    </button>
                </div>

                <!-- SIN BEBIDAS -->
                <div v-else-if="bebidas.length === 0" class="message-container">
                    <p>Por el momento no hay bebidas disponibles.</p>
                </div>

                <!-- TARJETAS DINÁMICAS -->
                <div v-else class="drinks-grid">

                    <article class="drink-card" v-for="(bebida, index) in bebidas" :key="bebida.id_bebida">
                        <img :src="obtenerImagen(bebida.tipo)" :alt="bebida.nombre" />

                        <div class="drink-info">

                            <span class="drink-number">
                                {{ String(index + 1).padStart(2, '0') }}
                            </span>

                            <h3>{{ bebida.nombre }}</h3>

                            <p>
                                {{
                                    bebida.descripcion ||
                                    'Una deliciosa opción para disfrutar.'
                                }}
                            </p>

                            <div class="drink-type">
                                {{ formatearTipo(bebida.tipo) }}
                            </div>

                            <div class="drink-price">
                                ${{ Number(bebida.precio).toFixed(2) }}
                            </div>

                        </div>
                    </article>

                </div>
            </section>

            <!-- CIERRE -->
            <section class="closing-section">
                <span class="section-label">TU MOMENTO, TU LUGAR</span>

                <h2>Desconecta de lo cotidiano</h2>

                <p>
                    Déjate envolver por el ambiente, disfruta de las vistas y vive
                    la esencia de AUREVANT.
                </p>
            </section>

        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

import {
    IonPage,
    IonContent,
    IonSpinner
} from '@ionic/vue';

const API_URL = 'http://127.0.0.1:8000/api';

// INTERFAZ DE BEBIDAS
interface Bebida {
    id_bebida: number;
    nombre: string;
    descripcion: string | null;
    precio: number | string;
    tipo: string;
    ingredientes: string | null;
}

// ESTADOS
const bebidas = ref<Bebida[]>([]);
const cargandoBebidas = ref(false);
const errorBebidas = ref('');

// CARGAR BEBIDAS DESDE LARAVEL
async function cargarBebidas() {
    cargandoBebidas.value = true;
    errorBebidas.value = '';

    try {
        const respuesta = await fetch(`${API_URL}/bebidas-publicas`, {
            method: 'GET',
            headers: {
                Accept: 'application/json'
            }
        });

        if (!respuesta.ok) {
            throw new Error('No fue posible cargar las bebidas.');
        }

        const datos: Bebida[] = await respuesta.json();

        // Guardar las bebidas recibidas desde Laravel
        bebidas.value = datos;

    } catch (error) {
        console.error('Error al cargar bebidas:', error);

        errorBebidas.value =
            'No se pudieron cargar las bebidas. Verifica que Laravel esté funcionando.';
    } finally {
        cargandoBebidas.value = false;
    }
}

// IMAGEN SEGÚN EL TIPO DE BEBIDA
function obtenerImagen(tipo: string): string {

    const imagenes: Record<string, string> = {
        coctel: 'https://images.unsplash.com/photo-1513558161293-cdaf765edfd4?auto=format&fit=crop&w=800&q=85',

        jugo: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=800&q=85',

        refresco: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=800&q=85',

        cafe: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=85',

        agua: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?auto=format&fit=crop&w=800&q=85'
    };

    return imagenes[String(tipo).toLowerCase()] ||
        'https://images.unsplash.com/photo-1513558161293-cdaf765edfd4?auto=format&fit=crop&w=800&q=85';
}

// MOSTRAR EL TIPO CON FORMATO BONITO
function formatearTipo(tipo: string): string {
    if (!tipo) return 'Bebida';

    return tipo.charAt(0).toUpperCase() + tipo.slice(1);
}

// CARGAR AL ENTRAR AL TAB
onMounted(() => {
    cargarBebidas();
});
</script>

<style scoped>
.bar-page {
    --background: #f6f1e7;
    background: #f6f1e7;
}

.bar-content {
    --background: #f6f1e7;
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
    background: linear-gradient(180deg,
            rgba(18, 39, 28, 0.35),
            rgba(4, 14, 9, 0.8));
}

.hero-content {
    position: relative;
    z-index: 1;
    padding: 24px;
    color: #fffaf0;
}

.eyebrow {
    color: #e4c887;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 2.5px;
}

.hero h1 {
    margin: 15px 0 10px;
    font-family: Georgia, 'Times New Roman', serif;
    font-size: clamp(52px, 10vw, 78px);
    font-weight: 400;
    letter-spacing: 2px;
}

.gold-line {
    width: 58px;
    height: 2px;
    margin: 0 auto 15px;
    background: #d7b574;
}

.hero-content p {
    margin: 0;
    font-size: 16px;
    letter-spacing: 0.5px;
}

/* SECCIONES */
.section {
    padding: 42px 24px;
}

.section-label {
    color: #9a7b42;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 2px;
}

.intro {
    max-width: 780px;
    margin: 0 auto;
    text-align: center;
}

.intro h2,
.section-heading h2,
.experience-text h2,
.closing-section h2 {
    color: #0f3d2e;
    font-family: Georgia, 'Times New Roman', serif;
    font-weight: 400;
    line-height: 1.2;
}

.intro h2 {
    margin: 16px 0;
    font-size: 36px;
}

.intro p,
.experience-text p,
.closing-section p {
    color: #65665e;
    font-size: 16px;
    line-height: 1.9;
}

/* EXPERIENCIA */
.experience {
    display: grid;
    grid-template-columns: 1fr 1fr;
    align-items: stretch;
    background: #eae2d2;
}

.experience>img {
    display: block;
    width: 100%;
    height: 100%;
    min-height: 300px;
    object-fit: cover;
}

.experience-text {
    padding: 38px 30px;
    align-self: center;
}

.experience-text h2 {
    margin: 16px 0;
    font-size: 32px;
}

/* BEBIDAS */
.drinks-section {
    max-width: 1150px;
    margin: 0 auto;
}

.section-heading {
    margin-bottom: 28px;
    text-align: center;
}

.section-heading h2 {
    margin-top: 14px;
    font-size: 32px;
}

.drinks-description {
    color: #65665e;
    font-size: 15px;
    line-height: 1.7;
}

.drinks-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 22px;
}

.drink-card {
    overflow: hidden;
    background: #fffdf7;
    border: 1px solid #e6ddca;
    border-radius: 5px;
    box-shadow: 0 5px 18px rgba(27, 44, 33, 0.07);
    transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.drink-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(27, 44, 33, 0.13);
}

.drink-card img {
    display: block;
    width: 100%;
    height: 190px;
    object-fit: cover;
    object-position: center;
}

.drink-info {
    padding: 22px;
}

.drink-number {
    color: #ad8c4b;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 2px;
}

.drink-info h3 {
    margin: 10px 0;
    color: #0f3d2e;
    font-family: Georgia, 'Times New Roman', serif;
    font-size: 25px;
    font-weight: 400;
}

.drink-info p {
    margin: 0;
    color: #696a61;
    font-size: 15px;
    line-height: 1.8;
}

.drink-type {
    display: inline-block;
    margin-top: 15px;
    padding: 5px 10px;
    border: 1px solid #e6ddca;
    border-radius: 20px;
    color: #8a7041;
    font-size: 12px;
}

.drink-price {
    margin-top: 17px;
    padding-top: 13px;
    border-top: 1px solid #e6ddca;
    color: #9a7b42;
    font-size: 20px;
    font-weight: 700;
}

/* CARGANDO Y MENSAJES */
.loading-container,
.message-container {
    padding: 35px 15px;
    text-align: center;
    color: #65665e;
}

.loading-container ion-spinner {
    width: 35px;
    height: 35px;
    color: #0f3d2e;
}

.loading-container p {
    margin-top: 12px;
}

.retry-button {
    margin-top: 12px;
    padding: 11px 20px;
    border: none;
    border-radius: 4px;
    background: #0f3d2e;
    color: #fffdf7;
    cursor: pointer;
}

/* CIERRE */
.closing-section {
    padding: 48px 25px;
    background: #0f3d2e;
    color: #f6f1e7;
    text-align: center;
}

.closing-section .section-label {
    color: #e0c17e;
}

.closing-section h2 {
    margin: 16px 0;
    color: #fffaf0;
    font-size: 34px;
}

.closing-section p {
    max-width: 560px;
    margin: 0 auto;
    color: #e2e4dc;
}

/* RESPONSIVE */
@media (max-width: 800px) {
    .drinks-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 600px) {
    .hero {
        height: 320px;
    }

    .section {
        padding: 32px 18px;
    }

    .intro h2 {
        font-size: 32px;
    }

    .experience {
        grid-template-columns: 1fr;
    }

    .experience>img {
        height: 230px;
        min-height: 230px;
    }

    .experience-text {
        padding: 30px 22px;
    }

    .experience-text h2 {
        font-size: 29px;
    }

    .drinks-grid {
        grid-template-columns: 1fr;
        gap: 17px;
    }

    .drink-card {
        display: grid;
        grid-template-columns: 42% 1fr;
        align-items: stretch;
    }

    .drink-card img {
        height: 100%;
        min-height: 155px;
    }

    .drink-info {
        padding: 17px 14px;
    }

    .drink-info h3 {
        font-size: 22px;
    }

    .drink-info p {
        font-size: 14px;
    }

    .closing-section {
        padding: 38px 20px;
    }

    .closing-section h2 {
        font-size: 29px;
    }
}
</style>