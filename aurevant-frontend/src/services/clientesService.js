import axios from 'axios'
const API = 'http://localhost:8000/api'
const auth = () => {
  const token = localStorage.getItem('token')
  return {
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json'
    }
  }
}
export const listarClientes = () => axios.get(`${API}/clientes`, auth())
export const crearCliente = (datos) => axios.post(`${API}/clientes`, datos, auth())
export const actualizarCliente = (id, datos) => axios.put(`${API}/clientes/${id}`, datos, auth())
