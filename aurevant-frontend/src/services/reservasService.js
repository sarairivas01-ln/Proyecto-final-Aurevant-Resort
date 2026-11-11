import axios from 'axios'
const API = 'http://localhost:8000/api'
const auth = () => {
  const token = localStorage.getItem('token')
  return token ? { headers: { Authorization: `Bearer ${token}` } } : {}
}
export const listarReservas = () => axios.get(`${API}/reservas`, auth())
export const crearReserva = (datos) => axios.post(`${API}/reservas`, datos, auth())
export const actualizarReserva = (id, datos) => axios.put(`${API}/reservas/${id}`, datos, auth())
export const eliminarReserva = (id) => axios.delete(`${API}/reservas/${id}`, auth())
export const extenderReserva = (id, fecha_fin) =>
  axios.post(`${API}/reservas/${id}/extender`, { fecha_fin }, auth())
export const listarReservaciones = listarReservas
export const crearReservacion = crearReserva
export const actualizarReservacion = actualizarReserva
export const eliminarReservacion = eliminarReserva
