
export default () => ({
  root: {
    height: '100vh',

    '& a': {
      textDecoration: 'none',
      color: 'inherit',

      '&:hover, &:visited, &:active': {
        color: 'inherit'
      }
    }
  },
})
