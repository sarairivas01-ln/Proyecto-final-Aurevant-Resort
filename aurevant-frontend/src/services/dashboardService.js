import api from '@/services/api'
export const obtenerDashboard = () => api.get('/dashboard')
