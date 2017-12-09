import React from 'react';
import { compose, pure } from 'recompose'

import { withStyles } from 'material-ui/styles'
import MuiGrid from 'material-ui/Grid'

import classnames from 'classnames'

import styles from './styles'

const Grid = ({ classes, flex, className, ...rest }) => (
  <MuiGrid
    { ...rest }
    className={ classnames(
      classes.root,
      flex && classes.flex,
      className
    ) }
  />
)

export default compose(
  pure,
  withStyles(styles)
)(Grid);
