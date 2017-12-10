import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import classnames from 'classnames'
import Paper from 'material-ui/Paper'
import Typography from 'material-ui/Typography'

import styles from './styles'

const PageBlock = ({ classes, title, maxWidth, children }) => (
  <Paper
    square
    elevation="0"
    classes={{
      root: classnames(
        classes.root,
        maxWidth && classes.maxWidth
      )
    }}
  >
    { title && <Typography type="subheading" paragraph>{ title }</Typography> }
    <div>
      { children }
    </div>
  </Paper>
)

export default compose(
  pure,
  withStyles(styles)
)(PageBlock);
