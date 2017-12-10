import React from 'react';
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'graphql/queries'
import { scheduleJob } from 'graphql/mutations'
import { SubmissionError } from 'redux-form'

import { graphql } from 'react-apollo'

import Page from 'components/Page'
import ReposList from 'containers/blocks/ReposList'
import ScheduleJobForm from 'containers/forms/ScheduleJobForm'

import Typography from 'material-ui/Typography'
import Paper from 'material-ui/Paper'
import Grid from 'material-ui/Grid'

import styles from './styles'

const ReposListPage = ({ classes, data, children, onSubmit }) => (
  <Page>
    <Typography type="display2" align="center">
      What is ElixirBench?
    </Typography>
    <Typography type="headline" align="center">
      Long Running Benchmarks for Elixir Projects
    </Typography>
    <div className={ classes.repos }>
      <Grid container spacing={ 24 }>
        <Grid item xs={ 12 } sm={ 12 } md={ 4 }>
          <Typography type="headline" align="left" paragraph>
            Popular repositories
          </Typography>
          <ReposList repos={ data.repos } />
        </Grid>
        <Grid item xs={ 12 } sm={ 12 } md={ 8 }>
          <Typography type="headline" align="left" paragraph>
            Test your own repo
          </Typography>
          <div className={ classes.form }>
            <ScheduleJobForm onSubmit={ onSubmit } />
          </div>
        </Grid>
      </Grid>
    </div>
  </Page>
)

export default compose(
  pure,
  graphql(getRepos),
  graphql(scheduleJob),
  withStyles(styles),
  withHandlers({
    onSubmit: ({ mutate, router }) => values => (
      mutate({
        variables: values
      }).then(({ data }) => {
        router.push(`/job/${data.scheduleJob.id}`)
      }).catch((error, ...args) => {
        throw new SubmissionError({
          _error: error.message
        })
      })
    )
  })
)(ReposListPage);
