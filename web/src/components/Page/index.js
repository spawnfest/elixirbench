import React from 'react';
import { compose, pure } from 'recompose'
import { Link } from 'react-router'
import { withStyles } from 'material-ui/styles'

import Typography from 'material-ui/Typography'
import KeyboardArrowLeft from 'material-ui-icons/KeyboardArrowLeft'

import Grid from 'components/Grid'

import styles from './styles'

const Page = ({ classes, title, backLink, backTitle, children }) => (
  <div className={ classes.root }>
    <Grid container direction="column" wrap="nowrap">
      { backLink && (
        <Grid item>
          <Link to={ backLink }>
            <Grid container direction="row" wrap="nowrap" alignItems="center">
              <Grid item>
                <KeyboardArrowLeft />
              </Grid>
              <Grid item>
                <Typography type="body1">{ backTitle }</Typography>
              </Grid>
            </Grid>
          </Link>
        </Grid>
      )}
      <Grid item>
        <Grid container direction="row" wrap="nowrap" alignItems="center">
          <Grid item>
            <Typography type="subheading">{ title }</Typography>
          </Grid>
        </Grid>
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
