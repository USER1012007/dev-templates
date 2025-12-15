import { createContext, useEffect, useState } from 'react'
import { api } from '../lib/api'

type User = {
  id: number
  name: string
  email: string
}

export type AuthContextType = {
  user: User | null
  loading: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => Promise<void>
}

export const AuthContext = createContext<AuthContextType>(
  {} as AuthContextType
)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let mounted = true

    const loadUser = async () => {
      try {
        const { data } = await api.get('/api/user')
        if (mounted) setUser(data)
      } catch {
        if (mounted) setUser(null)
      } finally {
        if (mounted) setLoading(false)
      }
    }

    loadUser()
    return () => {
      mounted = false
    }
  }, [])

  const login = async (email: string, password: string) => {
    await api.get('/sanctum/csrf-cookie')
    await api.post('/login', { email, password })
    const { data } = await api.get('/api/user')
    setUser(data)
  }

  const logout = async () => {
    await api.post('/logout')
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}
