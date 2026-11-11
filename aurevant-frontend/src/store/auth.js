import api from '@/services/api'
export default {
  namespaced: true,
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: JSON.parse(localStorage.getItem('user') || 'null'),
  }),
  getters: {
    autenticado: (state) => !!state.token,
    usuario: (state) => state.user,
    rol: (state) => state.user?.rol || null,
    isAdmin: (state) => state.user?.rol === 'admin',
isRecepcion: (state) => state.user?.rol === 'recepcion',
  },
  mutations: {
    SET_SESSION(state, { token, user }) {
      state.token = token
      state.user = user
    },
    CLEAR(state) {
      state.token = null
      state.user = null
    },
  },
  actions: {
    async login({ commit }, { email, password }) {
      const { data } = await api.post('/login', { email, password })
      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data.user))
      commit('SET_SESSION', { token: data.token, user: data.user })
      return data
    },
    logout({ commit }) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      commit('CLEAR')
    },
  },
}
