import React from 'react';
import { withRouter } from 'react-router'
import { compose, pure, withHandlers } from 'recompose'
import Button from 'material-ui/Button'
import Typography from 'material-ui/Typography'

import Page from 'components/Page'

const NotFoundPage = ({ onClickGoToHomePage }) => (
  <Page>
    <Typography type="display2" paragraph gutterBottom>
      Page not found ¯\_(ツ)_/¯
    </Typography>
    <Typography type="body1" paragraph>
      You may have mistyped the address or the page may have moved.
    </Typography>
    <Button color="primary" raised onClick={ onClickGoToHomePage }>Go to home page</Button>
  </Page>
)

export default compose(
  pure,
  withRouter,
  withHandlers({
    onClickGoToHomePage: ({ router }) => () => (
      router.push('/')
    )
  })
)(NotFoundPage);
