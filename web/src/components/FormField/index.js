import React from 'react';
import { compose, pure, withPropsOnChange } from 'recompose'
import { withStyles } from 'material-ui/styles';

import { ErrorMessages } from 'react-nebo15-validate'
import TextField from 'material-ui/TextField'
import Typography from 'material-ui/Typography'

import styles from './styles'

const Component = ({ classes, input, meta, error, children, ...rest }) => (
  <div className={ classes.root }>
    <TextField
      { ...rest }
      { ...input }
      error={ !!error }
      margin="none"
    />
    <Typography color="error" type="caption" className={ classes.error }>
      <ErrorMessages error={ error }>
        { children }
      </ErrorMessages>
    </Typography>
  </div>
)

export default compose(
  pure,
  withPropsOnChange(
    ['meta'],
    ({ meta }) => ({
      error: (meta.visited && meta.dirty || meta.submitFailed) && meta.error
    })
  ),
  withStyles(styles)
)(Component);
