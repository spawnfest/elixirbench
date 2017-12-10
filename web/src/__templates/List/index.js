import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import MuiList from 'material-ui/List'

import ListItem from './ListItem'
import styles from './styles'

const List = ({ repos = [] }) => (
  <MuiList>
    { repos.map(repo => (
      <ListItem key={ repo.slug } { ...repo } />
    ))}
  </MuiList>
)

export default compose(
  pure,
  withStyles(styles)
)(List);
