import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { getRepos } from 'schemas'
import { graphql } from 'react-apollo'

import styles from './styles'

const ReposListPage = ({ classes, children }) => (
  <div className={ classes.root }>
    Repos list
  </div>
)

export default compose(
  pure,
  graphql(getRepos),
  withStyles(styles)
)(ReposListPage);
