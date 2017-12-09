import gql from 'graphql-tag'

export const getRepos = gql`
  query TodoAppQuery {
    repos {
      slug
      user
      owner
    }
  }
`
