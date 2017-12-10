import 'typeface-roboto'
import React from 'react'
import { Provider  } from 'react-redux'
import { ApolloProvider } from 'react-apollo'

import Routes from 'routes'

const App = ({ apolloClient,store, history }) => (
  <ApolloProvider client={ apolloClient }>
    <Provider store={ store }>
      <Routes history={ history } store={ store }/>
    </Provider>
  </ApolloProvider>
)

export default App
