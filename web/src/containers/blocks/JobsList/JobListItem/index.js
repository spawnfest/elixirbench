import React from 'react';
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles';

import { ListItem, ListItemText } from 'material-ui/List'

import styles from './styles'

const LastJobItem = ({ key, job, classes, onClick, children }) => (
  <ListItem key={ key } button divider>
    <ListItemText
      primary={ `${job.repoSlug} : ${job.branchName} # ${job.commitSha.slice(0, 6)}` }
      onClick={ onClick }
    />
  </ListItem>
)

export default compose(
  pure,
  withHandlers({
    onClick: ({ job, onClick }) => (e) => (
      onClick(e, job)
    )
  }),
  withStyles(styles)
)(LastJobItem);
