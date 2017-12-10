import React from 'react'
import { get } from 'lodash'
import { withRouter } from 'react-router'
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getRepo } from 'queries'
import { graphql } from 'react-apollo'

import Typography from 'material-ui/Typography'
import Page from 'components/Page'
import BenchmarksList from 'containers/blocks/BenchmarksList'
import styles from './styles'

const RepoDetails = ({ classes, data, children, onBenchmarkClick }) => (
  <Page title={ get(data, 'repo.name') }>
    <Typography type="title">Benchmarks</Typography>
    <BenchmarksList
      benchmarks={ get(data, 'repo.benchmarks') }
      onBenchmarkClick={ onBenchmarkClick }
    />
  </Page>
)

export default compose(
  pure,
  withRouter,
  graphql(getRepo, {
    options: (props) => ({
      variables: {
        slug: `${props.params.owner}/${props.params.repo}`,
      }
    })
  }),
  withHandlers({
    onBenchmarkClick: ({ router, params,repo }) => (e, benchmark) => (
      router.push(`/repos/${params.owner}/${params.repo}/benchmark/${benchmark.name}`)
    )
  }),
  withStyles(styles)
)(RepoDetails);
