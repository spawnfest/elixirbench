import React from 'react'
import ReactDOM from 'react-dom'
import { createHashHistory } from 'history'

import registerServiceWorker from './registerServiceWorker'
import createStore from './services/store'
import App from './App'

const history = createHashHistory()
const store = createStore({ history })

ReactDOM.render((
  <App
    store={ store }
    history={ history }
  />
), document.getElementById('root'));

registerServiceWorker();
