import React from 'react';
import { compose, pure, withPropsOnChange } from 'recompose'
import { isEmpty } from 'lodash'
import { withStyles } from 'material-ui/styles';

import nl2br from 'react-nl2br'

import styles from './styles'

const Logs = ({ classes, children, log, multilineLog, onRestartClick }) => (
  <div className={ classes.root }>
    { isEmpty(log) ? (
      <div className={ classes.empty }>We don't have any logs. Try to wait or <a onClick={onRestartClick}>restart the job</a>.</div>
    ) : <div>
      { multilineLog }
    </div> }
  </div>
)

export default compose(
  pure,
  withPropsOnChange(
    ['log'],
    ({ log }) => ({
      multilineLog: nl2br(log),
    })
  ),
  withStyles(styles)
)(Logs);
