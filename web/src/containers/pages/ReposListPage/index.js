import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import ReposList from 'containers/blocks/ReposList'
import Typography from 'material-ui/Typography'

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
      <div className={ classes.scheduleJob }>
        <SchedulJobForm onSubmit={ v => console.log(v) } />
      </div>
      <Typography type="headline" align="left">
        Popular repositories
      </Typography>
      <ReposList repos={ data.repos } />
    </div>
  </Page>
)

export default compose(
  pure,
  graphql(getRepos),
  withStyles(styles)
)(ReposListPage);
