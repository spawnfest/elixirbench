import React from 'react';
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { withRouter } from 'react-router'
import { ListItem as MuiListItem, ListItemText as MuiListItemText } from 'material-ui/List'

import styles from './styles'

const ListItem = ({ key, benchmark, onClick }) => (
  <MuiListItem key={ key } button onClick={ onClick }>
    <MuiListItemText primary={ benchmark.name } />
  </MuiListItem>
)

export default compose(
  pure,
  withRouter,
  withStyles(styles),
  withHandlers({
    onClick: ({ benchmark, onClick }) => (e) => (
      onClick(e, benchmark)
    )
  }),
)(ListItem);
