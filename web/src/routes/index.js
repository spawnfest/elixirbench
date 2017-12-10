import React from 'react'
import { IndexRoute, Router, Route, IndexRedirect } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import AppLayout from 'containers/layouts/AppLayout'
import NotFoundPage from 'containers/pages/NotFoundPage'
import ReposListPage from 'containers/pages/ReposListPage'
import RepoDetailsPage from 'containers/pages/RepoDetailsPage'
import BenchmarkDetailsPage from 'containers/pages/BenchmarkDetailsPage'

export default ({ store, history }) => (
  <Router history={ syncHistoryWithStore(history, store) }>
    <Route path="/" component={ AppLayout }>
      <IndexRedirect to="repos" />
      <Route path="repos">
        <IndexRoute component={ ReposListPage } />
        <Route path=":owner/:repo">
          <IndexRoute component={ RepoDetailsPage } />
          <Route path="benchmark/*" component={ BenchmarkDetailsPage } />
        </Route>
      </Route>
      <Route path="*" component={ NotFoundPage } />
    </Route>
  </Router>
)
