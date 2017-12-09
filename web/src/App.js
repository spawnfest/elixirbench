import React from 'react'
import { Provider  } from 'react-redux'
import Routes from './routes'

const App = ({ store, history }) => (
  <Provider store={ store }>
    <Routes history={ history } store={ store }/>
  </Provider>
)

export default App
