import React from 'react'
import { get } from 'lodash'
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getRepo } from 'queries'
import { graphql } from 'react-apollo'

import Page from 'components/Page'
import RepoList from 'containers/blocks/RepoList'

import styles from './styles'

const RepoDetails = ({ classes, data, children }) => (
  <Page title={ get(data, 'repo.name') }></Page>
)

export default compose(
  pure,
  graphql(getRepo, {
    options: (props) => ({
      variables: {
        slug: props.params.splat
      }
    })
  }),
  withStyles(styles)
)(RepoDetails);
