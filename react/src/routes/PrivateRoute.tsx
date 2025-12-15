import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/useAuth'

export default function PrivateRoute({ children }: { children: JSX.Element }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <span className="text-gray-500">Cargando...</span>
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return children;
}
