import { listarHabitaciones } from '@/services/habitacionesService'
const state = () => ({
  items: [],
  cargando: false,
  error: null
})
const getters = {
  disponibles: (s) => s.items.filter(h => h.activa && h.estado === 'Disponible').length,
  ocupadas: (s) => s.items.filter(h => h.activa && h.estado === 'Ocupada').length,
  enMantenimiento: (s) => s.items.filter(h => h.activa && h.estado === 'Mantenimiento').length,
  enLimpieza: (s) => s.items.filter(h => h.activa && h.estado === 'Limpieza').length,
  inactivas: (s) => s.items.filter(h => !h.activa).length,
  total: (s) => s.items.length
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
      const { data } = await listarHabitaciones()
      commit('SET_ITEMS', data)
    } catch (e) {
      commit('SET_ERROR', 'No se pudieron cargar las habitaciones.')
    } finally {
      commit('SET_CARGANDO', false)
    }
  }
}
export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
