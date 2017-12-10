import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import ReposList from 'containers/blocks/ReposList'
import ScheduleJobForm from 'containers/forms/ScheduleJobForm'

import Typography from 'material-ui/Typography'
import Paper from 'material-ui/Paper'
import Grid from 'material-ui/Grid'

import styles from './styles'

const ReposListPage = ({ classes, data, children }) => (
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
            <ScheduleJobForm onSubmit={ v => console.log(v) } />
          </div>
        </Grid>
      </Grid>
      <Paper className={ classes.scheduleJob }>

      </Paper>
    </div>
  </Page>
)

export default compose(
  pure,
  graphql(getRepos),
  withStyles(styles)
)(ReposListPage);
