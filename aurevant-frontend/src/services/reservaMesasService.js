import api from '@/services/api'

export const listarReservaMesas = () => api.get('/reserva-mesas')
export const crearReservaMesa   = (datos) => api.post('/reserva-mesas', datos)
export const cambiarEstadoReserva = (id, estado) =>
  api.patch(`/reserva-mesas/${id}/estado`, { estado })
export const misReservasMesa    = () => api.get('/mis-reservas-mesa')
