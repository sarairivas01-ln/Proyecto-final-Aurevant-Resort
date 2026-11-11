// src/store/reservaciones.js
import { listarReservas, crearReserva, actualizarReserva, eliminarReserva } from '@/services/reservasService'
const state = () => ({
  items: [],
  cargando: false,
  error: null
})
const getters = {
  confirmadas: (s) => s.items.filter(r => r.estado === 'Confirmada').length,
  pendientes:  (s) => s.items.filter(r => r.estado === 'Pendiente').length,
  canceladas:  (s) => s.items.filter(r => r.estado === 'Cancelada').length,
  finalizadas: (s) => s.items.filter(r => r.estado === 'Finalizada').length,
  total:       (s) => s.items.length
}
const mutations = {
  SET_ITEMS(state, items) { state.items = items },
  SET_CARGANDO(state, v) { state.cargando = v },
  SET_ERROR(state, e) { state.error = e }
}
const actions = {
  async cargar({ commit }) {
    commit('SET_CARGANDO', true)
    commit('SET_ERROR', null)
    try {
      const { data } = await listarReservas()
      commit('SET_ITEMS', data)
    } catch (e) {
      commit('SET_ERROR', 'No se pudieron cargar las reservaciones.')
    } finally {
      commit('SET_CARGANDO', false)
    }
  },
  async guardar({ dispatch }, reserva) {
    if (reserva.id_reserva) {
      await actualizarReserva(reserva.id_reserva, reserva)
    } else {
      await crearReserva(reserva)
    }
    await dispatch('cargar')
  },
  async eliminar({ dispatch }, id) {
    await eliminarReserva(id)
    await dispatch('cargar')
  }
}
export default { namespaced: true, state, getters, mutations, actions }
