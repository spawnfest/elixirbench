import { createStore, applyMiddleware } from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'

import reducers from 'reducers'

const middlewares = []

export default ({ history }) => createStore(
  reducers,
  composeWithDevTools(
    applyMiddleware(...middlewares),
  )
)
