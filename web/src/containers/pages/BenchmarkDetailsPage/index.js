import React from 'react'
import { get } from 'lodash'
import { withRouter } from 'react-router'
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getRepo } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import styles from './styles'

const BenchmarkDetailsPage = ({ classes, children }) => (
  <Page title="Benchmark details">
  </Page>
)

export default compose(
  pure,
  withRouter,
  // graphql(getRepo, {
  //   options: (props) => ({
  //     variables: {
  //       slug: props.params.splat
  //     }
  //   })
  // }),
  withStyles(styles)
)(BenchmarkDetailsPage);
