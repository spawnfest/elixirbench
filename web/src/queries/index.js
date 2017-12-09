import gql from 'graphql-tag'

export const getRepos = gql`
  query {
    repos {
      name
      slug
      owner
    }
  }
`

export const getRepo = gql`
  query ($slug: String) {
    repo(slug: $slug) {
      name
      slug
      owner
    }
  }
`
