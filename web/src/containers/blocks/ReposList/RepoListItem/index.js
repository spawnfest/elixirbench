import React from 'react';
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { withRouter } from 'react-router'
import { ListItem, ListItemText } from 'material-ui/List'

import styles from './styles'

const RepoListItem = ({ key, name, slug, onClick }) => (
  <ListItem divider key={ key } button onClick={ onClick }>
    <ListItemText primary={ slug } />
  </ListItem>
)

export default compose(
  pure,
  withRouter,
  withStyles(styles),
  withHandlers({
    onClick: ({ slug, router }) => () => (
      router.push(`/repos/${slug}`)
    )
  }),
)(RepoListItem);
