import React from 'react'
import { get, mapValues, round } from 'lodash'

import { withRouter } from 'react-router'
import { compose, pure, withProps } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getJob } from 'graphql/queries'
import { graphql } from 'react-apollo'

import { Line, Area } from 'recharts'

import Typography from 'material-ui/Typography'
import Page from 'components/Page'
import PageBlock from 'components/PageBlock'

import MeasurementsChart from 'containers/blocks/MeasurementsChart'

import styles from './styles'

const BenchmarkDetailsPage = ({ classes, data, children }) => (
  <Page
    backLink="/"
    backTitle="Back to home page"
  >
  </Page>
)

export default compose(
  pure,
  withRouter,
  graphql(getJob, {
    options: ({ params: { jobId }}) => ({
      variables: {
        id: jobId,
      }
    })
  }),
  withStyles(styles),
)(BenchmarkDetailsPage);
