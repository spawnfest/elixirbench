import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import ReposList from 'containers/blocks/ReposList'

import styles from './styles'

const ReposListPage = ({ classes, data, children }) => (
  <Page title="Repos">
    <ReposList repos={ data.repos } />
  </Page>
)

export default compose(
  pure,
  graphql(getRepos),
  withStyles(styles)
)(ReposListPage);
