import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { router } from './router'
import { api } from './lib/api'
import { AuthProvider } from './context/AuthContext'
import './index.css'

api.get('/sanctum/csrf-cookie').catch(() => {
})

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <AuthProvider>
      <RouterProvider router={router} />
    </AuthProvider>
  </StrictMode>,
)
