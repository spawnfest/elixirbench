import React from 'react'
import { IndexRoute, Router, Route } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import IndexPage from 'views/IndexPage'

export default ({ store, history }) => (
  <Router history={ syncHistoryWithStore(history, store) }>
    <Route path="/">
      <IndexRoute component={ IndexPage } />
    </Route>
  </Router>
)
