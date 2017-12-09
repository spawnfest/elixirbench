import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import Typography from 'material-ui/Typography'

import Grid from 'components/Grid'

import styles from './styles'

const Page = ({ classes, title, children }) => (
  <div className={ classes.root }>
    <Grid container direction="column" wrap="nowrap">
      <Grid item>
        <Typography type="headline">{ title }</Typography>
      </Grid>
      <Grid item>
        { children }
      </Grid>
    </Grid>
  </div>
)

export default compose(
  pure,
  withStyles(styles)
)(Page);
