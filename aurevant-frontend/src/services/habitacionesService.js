import axios from 'axios'
const API_BASE = 'http://localhost:8000'
function auth() {
  const token = localStorage.getItem('token')
  return {
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json'
    }
  }
}
export async function listarHabitaciones() {
  return axios.get(`${API_BASE}/api/habitaciones`, auth())
}
