import { useState } from 'react'
import { AuthProvider } from './context/AuthContext';
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <AuthProvider>
        <div className="menu">
          <Menu />
        </div>
      </AuthProvider>
    </>
  )
}

export default App
