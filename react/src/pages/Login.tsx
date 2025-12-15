import { useState } from 'react';
import { useAuth } from '../context/useAuth'
import { Navigate } from 'react-router-dom';

export default function Login() {
  const { login, user } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  if (user) return <Navigate to="/" />;

  return (
    <form
      onSubmit={e => {
        e.preventDefault();
        login(email, password);
      }}
    >
      <input
        placeholder="Email"
        value={email}
        onChange={e => setEmail(e.target.value)}
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={e => setPassword(e.target.value)}
      />
      <button>Login</button>
    </form>
  );
}
