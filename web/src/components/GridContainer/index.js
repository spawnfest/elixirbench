import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';

import styles from './styles'

const GridContainer = ({ classes, children }) => (
  <div className={ classes.root }>
    { children }
  </div>
)

export default compose(
  pure,
  withStyles(styles)
)(GridContainer);
