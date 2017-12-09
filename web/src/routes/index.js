import React from 'react'
import { IndexRoute, Router, Route } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import AppLayout from 'containers/layouts/AppLayout'
import IndexPage from 'containers/pages/IndexPage'
import ReposListPage from 'containers/pages/ReposListPage'
import RepoDetailsPage from 'containers/pages/RepoDetailsPage'

export default ({ store, history }) => (
  <Router history={ syncHistoryWithStore(history, store) }>
    <Route path="/" component={ AppLayout }>
      <IndexRoute component={ IndexPage } />
      <Route path="repos">
        <IndexRoute component={ ReposListPage } />
        <Route path="*" component={ RepoDetailsPage } />
      </Route>
    </Route>
  </Router>
)
