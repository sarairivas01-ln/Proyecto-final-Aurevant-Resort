import { createStore } from 'vuex'
import auth from './auth'
import reservaciones from './reservaciones'
import habitaciones from './habitaciones'
export default createStore({
  modules: {
    auth,
    reservaciones, habitaciones } 
})
