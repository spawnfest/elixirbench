import React from 'react';
import { get } from 'lodash'
import { withRouter } from 'react-router'
import { compose, pure, withHandlers } from 'recompose'
import { withStyles } from 'material-ui/styles'

import List from 'material-ui/List'
import { getJobs } from 'graphql/queries'
import { graphql } from 'react-apollo'

import JobListItem from './JobListItem'
import styles from './styles'

const LastJobs = ({ classes, data, onJobClick, children }) => (
  <div className={ classes.root }>
    <List>
      { get(data, 'jobs', []).map(i => (
        <JobListItem key={ i.id } job={ i } onClick={ onJobClick }/>
      )) }
    </List>
    { children }
  </div>
)

export default compose(
  pure,
  withRouter,
  graphql(getJobs),
  withHandlers({
    onJobClick: ({ router }) => (e, job) => (
      router.push(`/job/${job.id}`)
    ),
  }),
  withStyles(styles)
)(LastJobs);
