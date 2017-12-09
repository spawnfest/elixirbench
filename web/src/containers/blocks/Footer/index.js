import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';

import Typography from 'material-ui/Typography'
import Grid from 'components/Grid'

import styles from './styles'

const Footer = ({ classes, children }) => (
  <Grid container justify="center">
    <Grid item>
      <Typography>
        { new Date().getFullYear() } ❤ ElixirChain
      </Typography>
    </Grid>
  </Grid>
)

export default compose(
  pure,
  withStyles(styles)
)(Footer);
