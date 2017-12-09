import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import List from 'material-ui/List'

import RepoListItem from './RepoListItem'
import styles from './styles'

const RepoList = ({ repos = [] }) => (
  <List>
    { repos.map(repo => (
      <RepoListItem key={ repo.slug } { ...repo } />
    ))}
  </List>
)

export default compose(
  pure,
  withStyles(styles)
)(RepoList);
