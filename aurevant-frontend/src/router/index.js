import { createRouter, createWebHistory } from 'vue-router'
const routes = [
  { path: '/', redirect: '/login' },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { publico: true }
  },
  {
    path: '/admin',
    component: () => import('@/layouts/DashboardLayout.vue'),
    children: [
      { path: '', redirect: '/admin/home' },
      { path: 'home', name: 'admin-home', component: () => import('@/views/admin/AdminDashboard.vue') },
      { path: 'habitaciones', name: 'admin-habitaciones', component: () => import('@/views/admin/HabitacionesView.vue') },
      { path: 'platillos', name: 'admin-platillos', component: () => import('@/views/admin/PlatillosView.vue') },
      { path: 'reservaciones', name: 'admin-reservaciones', component: () => import('@/views/admin/ReservacionesView.vue') },
      { path: 'clientes', name: 'admin-clientes', component: () => import('@/views/recepcion/ClientesView.vue') },
      { path: 'servicios', name: 'admin-servicios', component: () => import('@/views/admin/ServiciosView.vue') }
    ]
  },
  {
    path: '/recepcion',
    component: () => import('@/layouts/DashboardLayout.vue'),
    children: [
      { path: '', redirect: '/recepcion/home' },
      { path: 'home', name: 'recepcion-home', component: () => import('@/views/recepcion/RecepcionHome.vue') },
      { path: 'clientes', name: 'recepcion-clientes', component: () => import('@/views/recepcion/ClientesView.vue') },
      { path: 'reservas', name: 'recepcion-reservas', component: () => import('@/views/recepcion/ReservasView.vue') },
      { path: 'restaurante', name: 'recepcion-restaurante', component: () => import('@/views/recepcion/RestauranteView.vue') },
      { path: 'solicitudes', name: 'recepcion-solicitudes', component: () => import('@/views/recepcion/SolicitudesView.vue') },
      { path: 'servicios', name: 'recepcion-servicios', component: () => import('@/views/recepcion/ServiciosView.vue') }
    ]
  },
  { path: '/:pathMatch(.*)*', redirect: '/login' }
]
const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const publico = to.meta.publico === true
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  if (!token && !publico) return next('/login')
  if (token && to.path === '/login') {
    return next(user.rol === 'admin' ? '/admin/home' : '/recepcion/home')
  }
  if (token && to.path.startsWith('/admin') && user.rol !== 'admin') {
    return next('/recepcion/home')
  }
  if (token && to.path.startsWith('/recepcion') && user.rol !== 'recepcion') {
    return next('/admin/home')
  }
  next()
})
export default router
