import React from 'react'
import { IndexRoute, Router, Route } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import AppLayout from 'containers/layouts/AppLayout'
import IndexPage from 'containers/pages/IndexPage'

export default ({ store, history }) => (
  <Router history={ syncHistoryWithStore(history, store) }>
    <Route path="/" component={ AppLayout }>
      <IndexRoute component={ IndexPage } />
    </Route>
  </Router>
)
