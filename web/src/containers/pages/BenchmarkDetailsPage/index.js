import React from 'react'
import { get, mapValues, round } from 'lodash'

import { withRouter } from 'react-router'
import { compose, pure, withProps } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getBenchmark } from 'graphql/queries'
import { graphql } from 'react-apollo'

import { Line, Area } from 'recharts'

import Typography from 'material-ui/Typography'
import Page from 'components/Page'
import PageBlock from 'components/PageBlock'

import MeasurementsChart from 'containers/blocks/MeasurementsChart'

import styles from './styles'

const BenchmarkDetailsPage = ({ classes, data, params, measurements, children }) => (
  <Page
    backLink={`/repos/${params.owner}/${params.repo}`}
    backTitle="Back to the list of benchmarks"
  >
    <Typography type="headline">Measurements for <u>{ get(data, 'benchmark.name') }</u></Typography>
    <PageBlock title="Iteractions per second">
      <MeasurementsChart measurements={ measurements }>
        <Line dataKey="ips" type="monotone" title="IPS" />
      </MeasurementsChart>
    </PageBlock>
    <PageBlock title="Statistic">
      <MeasurementsChart measurements={ measurements }>
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
  withStyles(styles),
  withProps(({ data }) => ({
    measurements: get(data, 'benchmark.measurements', []).map(i => ({
      ...i,
      result: mapValues(i.result, i => round(i, 2)),
    }))
  }))
)(BenchmarkDetailsPage);
