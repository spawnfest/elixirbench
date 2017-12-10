import React from 'react'
import { get } from 'lodash'

import { withRouter } from 'react-router'
import { compose, pure, withHandlers, withPropsOnChange } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getJob } from 'graphql/queries'
import { scheduleJob } from 'graphql/mutations'

import { graphql } from 'react-apollo'

import Typography from 'material-ui/Typography'
import Card, { CardHeader } from 'material-ui/Card'
import Autorenew from 'material-ui-icons/Autorenew'

import Button from 'components/Button'
import Page from 'components/Page'
import PageBlock from 'components/PageBlock'
import Logs from 'components/Logs'

import styles from './styles'

const BenchmarkDetailsPage = ({ classes, data, githubUrl, onRestartClick, children }) => (
  <Page
    backLink="/"
    backTitle="Back to home page"
  >
    <Card>
      <CardHeader
        title={ `Job: ${ get(data, 'job.id') }` }
        subheader={ <a href={githubUrl} target="__blank" rel="nofollow noindex">See the commit in repo</a> }
        action={
          <div className={ classes.restartButton }>
            <Button rightIcon={ <Autorenew /> } onClick={ onRestartClick }>
              Restart
            </Button>
          </div>
        }
      />
    </Card>
    <PageBlock>
      <Typography type="title" paragraph>Logs</Typography>
      <Logs log={ get(data, 'job.log' )} onRestartClick={ onRestartClick }/>
    </PageBlock>
  </Page>
)

export default compose(
  pure,
  withRouter,
  graphql(getJob, {
    options: ({ params: { jobId }}) => ({
      variables: {
        id: jobId,
      }
    })
  }),
  graphql(scheduleJob),
  withPropsOnChange(
    ['data'],
    ({ data }) => ({
      githubUrl: `https://github.com/${get(data, 'job.repoSlug')}/commit/${get(data, 'job.commitSha')}`
    })
  ),
  withHandlers({
    onRestartClick: ({ mutate, router, data }) => () => {
      mutate({
        variables: {
          repoSlug: get(data, 'job.repoSlug'),
          branchName: get(data, 'job.branchName'),
          commitSha: get(data, 'job.commitSha'),
        }
      }).then(({ data }) => {
        router.push(`/job/${data.scheduleJob.id}`)
      })
    }
  }),
  withStyles(styles),
)(BenchmarkDetailsPage);
