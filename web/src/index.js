import React from 'react'
import ReactDOM from 'react-dom'
import { createHashHistory } from 'history'
import App from 'containers/App'

import registerServiceWorker from './registerServiceWorker'
import createStore from './services/store'
import createApolloClient from './services/apolloClient'

const history = createHashHistory()
const store = createStore({ history })
const apolloClient = createApolloClient()

ReactDOM.render((
  <App
    store={ store }
    history={ history }
    apolloClient={ apolloClient }
  />
), document.getElementById('root'));

registerServiceWorker();
