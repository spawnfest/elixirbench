import gql from 'graphql-tag'

export const scheduleJob = gql`
  mutation ScheduleJob($repoSlug: String!, $branchName: String!, $commitSha: String!) {
    scheduleJob(repoSlug: $repoSlug, branchName: $branchName, commitSha: $commitSha) {
      id
    }
  }
`
