import api from './api'
export const listarSolicitudes = () => api.get('/solicitudes')
export const aprobarSolicitud = (id) => api.post(`/solicitudes/${id}/aprobar`)
export const rechazarSolicitud = (id, motivo) =>
  api.post(`/solicitudes/${id}/rechazar`, { motivo })
