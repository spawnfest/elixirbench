import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';

import MuiButton from 'material-ui/Button'
import styles from './styles'

const Button = ({ classes, children, leftIcon, rightIcon, ...rest }) => (
  <MuiButton { ...rest }>
    { leftIcon && (
      <span className={ classes.leftIcon }>{ leftIcon }</span>
    ) }
    { children }
    { rightIcon && (
      <span className={ classes.rightIcon }>{ rightIcon }</span>
    ) }
  </MuiButton>
)

export default compose(
  pure,
  withStyles(styles)
)(Button);
