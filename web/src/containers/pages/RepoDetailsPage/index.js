import React from 'react'
import { get } from 'lodash'
import { withRouter, Link } from 'react-router'
import { compose, pure, withHandlers, withPropsOnChange } from 'recompose'
import { withStyles } from 'material-ui/styles'
import { getRepo } from 'queries'
import { graphql } from 'react-apollo'

import Typography from 'material-ui/Typography'
import Card, { CardHeader, CardActions, CardContent, CardMedia }  from 'material-ui/Card'
import IconButton from 'material-ui/IconButton'
import MoreVertIcon from 'material-ui-icons/MoreVert'

import Page from 'components/Page'
import PageBlock from 'components/PageBlock'

import BenchmarksList from 'containers/blocks/BenchmarksList'
import styles from './styles'

const RepoDetails = ({ classes, data, githubUrl, children, onBenchmarkClick, onRepoClick }) => (
  <Page
     backLink={`/repos`}
     backTitle="Back to the list of repos"
   >
    <Card>
      <CardHeader
        title={ get(data, 'repo.slug') }
        subheader={ <a href={githubUrl} target="__blank" rel="nofollow noindex">{githubUrl}</a> }
        action={
          <IconButton onClick={ onRepoClick }>
            <MoreVertIcon />
          </IconButton>
        }
      />
      {/* <CardContent>
        <Typography type="headline" component="h2">
          {  }
        </Typography>
        <Typography component="a" href={`https://github.com/${ get(data, 'repo.slug') }`}>
          { get(data, 'repo.slug') }
        </Typography>
      </CardContent> */}
    </Card>
    <PageBlock>
      <Typography type="title">Benchmarks</Typography>
      <BenchmarksList
        benchmarks={ get(data, 'repo.benchmarks') }
        onBenchmarkClick={ onBenchmarkClick }
      />
    </PageBlock>
  </Page>
)

export default compose(
  pure,
  withRouter,
  graphql(getRepo, {
    options: (props) => ({
      variables: {
        slug: `${props.params.owner}/${props.params.repo}`,
      }
    })
  }),
  withPropsOnChange(
    ['data'],
    ({ data }) => ({
      githubUrl: `https://github.com/${get(data, 'repo.slug')}`
    })
  ),
  withHandlers({
    onBenchmarkClick: ({ router, params,repo }) => (e, benchmark) => (
      router.push(`/repos/${params.owner}/${params.repo}/benchmark/${benchmark.name}`)
    ),
    onRepoClick: ({ router, githubUrl }) => () => (
      window.open(githubUrl, '__blank')
    )
  }),
  withStyles(styles)
)(RepoDetails);
