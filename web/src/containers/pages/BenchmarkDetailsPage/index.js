import React from 'react'
import { get } from 'lodash'
import { withRouter } from 'react-router'
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getBenchmark } from 'queries'
import { graphql } from 'react-apollo'

import { Line, Area } from 'recharts'

import Typography from 'material-ui/Typography'
import Page from 'components/Page'
import PageBlock from 'components/PageBlock'

import MeasurementsChart from 'containers/blocks/MeasurementsChart'

import styles from './styles'

const BenchmarkDetailsPage = ({ classes, data, children }) => (
  <Page title="Benchmark details">
    <Typography type="title">{ get(data, 'benchmark.name') }</Typography>
    <PageBlock title="Iteractions per second">
      <MeasurementsChart measurements={ get(data, 'benchmark.measurements') }>
        <Line dataKey="ips" type="monotone" title="IPS" />
      </MeasurementsChart>
    </PageBlock>
    <PageBlock title="Statistic">
      <MeasurementsChart measurements={ get(data, 'benchmark.measurements') }>
        <Area dataKey="minimum" stackId="range" />
        <Area dataKey="maximum" stackId="range" />
        <Line dataKey="average" />
        <Line dataKey="mode" />
      </MeasurementsChart>
    </PageBlock>
  </Page>
)

export default compose(
  pure,
  withRouter,
  graphql(getBenchmark, {
    options: ({ params: { owner, repo, splat }}) => ({
      variables: {
        repoSlug: `${owner}/${repo}`,
        name: splat
      }
    })
  }),
  withStyles(styles)
)(BenchmarkDetailsPage);
