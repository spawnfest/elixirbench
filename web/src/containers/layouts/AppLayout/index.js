import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'

import Grid from 'components/Grid'
import GridContainer from 'components/GridContainer'

import Navigation from 'containers/blocks/Navigation'
import Footer from 'containers/blocks/Footer'

import 'reset.css'
import styles from './styles'

const AppLayout = ({ classes, children }) => (
  <GridContainer>
    <Grid
      container
      spacing={ 0 }
      direction="column"
      wrap="nowrap"
      className={ classes.root }
    >
      <Grid item>
        <Navigation />
      </Grid>
      <Grid item flex>
        { children }
      </Grid>
      <Grid item>
        <Footer />
      </Grid>
    </Grid>
  </GridContainer>
)

export default compose(
  pure,
  withStyles(styles)
)(AppLayout);
