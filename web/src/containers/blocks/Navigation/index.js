import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { Link } from 'react-router'

import AppBar from 'material-ui/AppBar'
import Toolbar from 'material-ui/Toolbar'
import Typography from 'material-ui/Typography'
import Grid from 'material-ui/Grid'

import GridContainer from 'components/GridContainer'
import GithubLogo from 'components/GithubLogo'

import styles from './styles'

const Navigation = ({ classes, children }) => (
  <GridContainer className={ classes.root }>
    <AppBar position="static">
      <Toolbar>
        <Grid container justify="space-between" wrap="nowrap" alignItems="center">
          <Grid item>
            <Link to="/" className={ classes.logo }>
              <Typography type="title" color="inherit">
                  Elixir<b className={ classes.bolder }>Bench</b>
              </Typography>
            </Link>
          </Grid>
          <Grid item>
            <Grid container wrap="nowrap">
              <Grid item>
                <a
                  className={ classes.icon }
                  href={`https://github.com/spawnfest/elixirchain`}
                  rel="noreferrer nofollow"
                  target="__blank"
                >
                  <GithubLogo />
                </a>
              </Grid>
            </Grid>
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
