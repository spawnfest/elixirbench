import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import AppBar from 'material-ui/AppBar'
import Toolbar from 'material-ui/Toolbar'
import Typography from 'material-ui/Typography'
import Grid from 'material-ui/Grid'

import GridContainer from 'components/GridContainer'
import styles from './styles'

const Navigation = ({ classes, children }) => (
  <GridContainer className={ classes.root }>
    <AppBar position="static">
      <Toolbar>
        <Grid container>
          <Grid item>
            <Typography type="title" color="inherit">
              ElixirChain
            </Typography>
          </Grid>
        </Grid>
      </Toolbar>
    </AppBar>
  </GridContainer>
)

export default compose(
  pure,
  withStyles(styles)
)(Navigation);
