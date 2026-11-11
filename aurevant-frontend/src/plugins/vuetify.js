import 'vuetify/styles'
import '@mdi/font/css/materialdesignicons.css'
import { createVuetify } from 'vuetify'
import { es } from 'vuetify/locale'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

export default createVuetify({
  components,
  directives,
  locale: {
    locale: 'es',
    fallback: 'es',
    messages: { es }
  },
  theme: {
    defaultTheme: 'aurevant',
    themes: {
      aurevant: {
        dark: false,
        colors: {
          background: '#F7EFE3',
          surface: '#FFFFFF',
          primary: '#0F3D2E',
          secondary: '#D4B483',
          error: '#B4544C',
          warning: '#C99A4E',
          success: '#2E6E52',
          info: '#4A6FA5',
          'on-primary': '#F7EFE3',
          'on-secondary': '#1A1A1A',
          'on-background': '#1A1A1A',
          'on-surface': '#1A1A1A'
        }
      }
    }
  },
  defaults: {
    VCard: { rounded: 'lg', elevation: 0 },
    VBtn: { rounded: 'lg', class: 'text-none' },
    VChip: { rounded: 'pill' }
  }
})
