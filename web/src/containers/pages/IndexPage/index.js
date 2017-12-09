import React from 'react';
import { compose, pure } from 'recompose'
import Page from 'components/Page'

const IndexPage = () => (
  <Page title="Home page"></Page>
)

export default compose(
  pure
)(IndexPage);
