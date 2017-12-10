import React from 'react';
import { compose, pure } from 'recompose'
import { Link } from 'react-router'
import { withStyles } from 'material-ui/styles'
import classnames from 'classnames'

import Typography from 'material-ui/Typography'
import KeyboardArrowLeft from 'material-ui-icons/KeyboardArrowLeft'

import Grid from 'components/Grid'

import styles from './styles'

const Page = ({ classes, title, maxWidth, backLink, backTitle, children }) => (
  <div className={ classes.root }>
    <Grid container spacing={ 24 } direction="column" wrap="nowrap">
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
      { title && (
        <Grid item>
          <Grid container direction="row" wrap="nowrap" alignItems="center">
            <Grid item>
              <Typography type="subheading">{ title }</Typography>
            </Grid>
          </Grid>
        </Grid>
      )}
      <Grid item>
        <div
          className={ classnames(
            classes.root,
            maxWidth && classes.maxWidth
          ) }
        >
          { children }
        </div>
      </Grid>
    </Grid>
  </div>
)

export default compose(
  pure,
  withStyles(styles)
)(Page);
