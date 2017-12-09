import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import RepoList from 'containers/blocks/RepoList'

import styles from './styles'

const ReposListPage = ({ classes, data, children }) => (
  <Page title="Repos">
    <RepoList repos={ data.repos } />
  </Page>
)

export default compose(
  pure,
  graphql(getRepos),
  withStyles(styles)
)(ReposListPage);
