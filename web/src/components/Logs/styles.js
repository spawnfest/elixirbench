
export default () => ({
  root: {
    background: '#333',
    color: 'white',
    padding: 12,
    borderRadius: 4,
    lineHeight: '1.2',
    fontSize: 12,
    fontFamily: 'monospace',
    fontWeight: 'normal',
    maxHeight: 1200,
    overflowY: 'auto',

    '& a': {
      textDecoration: 'underline',
      cursor: 'pointer',
    }
  },
  empty: {
    padding: '40px 0',
    textAlign: 'center'
  }
})
