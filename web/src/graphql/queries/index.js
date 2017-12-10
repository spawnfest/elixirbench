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

export const getBenchmark = gql`
  query GetBenchmark ($name: String, $repoSlug: String) {
    benchmark(name: $name, repoSlug: $repoSlug) {
      name
      measurements {
        collectedAt
        commit {
          message
          sha
          url
        }
        environment {
          cpu
          cpuCount
          dependencyVersions {
            name
            version
          }
          elixirVersion
          erlangVersion
          memory
        }
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
`

export const getJobs = gql`
  query GetListOfRepos {
    jobs {
      id
      branchName
      repoSlug
      commitSha
      completedAt
      claimedAt
    }
  }
`

export const getJob = gql`
  query GetJobById ($id: String) {
    job(id: $id) {
      branchName
      claimedAt
      commitSha
      completedAt
      id
      log
      repoSlug
    }
  }
`
