import gql from 'graphql-tag'

export const getRepos = gql`
  query GetListOfRepos {
    repos {
      name
      slug
      owner
    }
  }
`

export const getRepo = gql`
  query GetRepoBySlug ($slug: String) {
    repo(slug: $slug) {
      name
      slug
      owner
      benchmarks {
        name
        measurements {
          collectedAt
          result {
            average
            ips
            maximum
            median
            minimum
            mode
            runTimes
            sampleSize
            stdDev
            stdDevIps
            stdDevRatio
          }
        }
      }
    }
  }
`
