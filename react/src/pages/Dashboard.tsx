import { useAuth } from '../context/useAuth'

export default function Dashboard() {
  const { user, logout } = useAuth()

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">
        Bienvenido, {user?.name}
      </h1>

      <button
        onClick={logout}
        className="mt-4 bg-red-600 text-white px-4 py-2"
      >
        Logout
      </button>
    </div>
  )
}
