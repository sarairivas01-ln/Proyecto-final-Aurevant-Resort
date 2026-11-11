import { reactive } from 'vue'

export const habitaciones = reactive([
  {
    id_habitacion: 1,
    numero: '101',
    tipo: 'Suite',
    capacidad: 2,
    precio_noche: 220.00,
    descripcion: 'Suite panorámica con ventanal de piso a techo hacia la cordillera y chimenea de piedra.',
    vista: 'Montaña',
    balcon: true,
    estado: 'Disponible',
    activa: true,
    img: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=600'
  },
  {
    id_habitacion: 2,
    numero: '102',
    tipo: 'Estándar',
    capacidad: 2,
    precio_noche: 95.00,
    descripcion: 'Habitación cálida con vigas de madera y cobijas de lana, vista al jardín de helechos.',
    vista: 'Jardín',
    balcon: false,
    estado: 'Ocupada',
    activa: true,
    img: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=600'
  },
  {
    id_habitacion: 3,
    numero: '201',
    tipo: 'Familiar',
    capacidad: 5,
    precio_noche: 260.00,
    descripcion: 'Dos habitaciones, sala con estufa de leña y acceso directo a los senderos del bosque.',
    vista: 'Bosque',
    balcon: true,
    estado: 'Mantenimiento',
    activa: true,
    img: 'https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=600'
  },
  {
    id_habitacion: 4,
    numero: '202',
    tipo: 'Suite',
    capacidad: 3,
    precio_noche: 310.00,
    descripcion: 'Suite amplia con balcón privado y vista directa a la montaña.',
    vista: 'Montaña',
    balcon: true,
    estado: 'Disponible',
    activa: true,
    img: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600'
  }
])
