import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import { reduxForm, Field } from 'redux-form'
import { reduxFormValidate } from 'react-nebo15-validate'

import Button from 'components/Button'
import FormField from 'components/FormField'
import Grid from 'components/Grid'
import ElixirBenchLogo from 'components/ElixirBenchLogo'

import styles from './styles'

const ScheduleJobForm = ({ classes, handleSubmit }) => (
  <form onSubmit={ handleSubmit } className={ classes.root } noValidate autoComplete="off">
    <Grid container>
      <Grid item>
        <Field
          name="repoSlug"
          label="Repo slug"
          component={ FormField }
        />
      </Grid>
      <Grid item>
        <Field
          name="branch"
          label="Branch"
          margin="normal"
          component={ FormField }
        />
      </Grid>
      <Grid item>
        <Field
          name="commit"
          label="Commit SHA"
          margin="normal"
          component={ FormField }
        />
      </Grid>
      <Grid item>
        <Button
          type="submit"
          color="primary"
          raised
          rightIcon={ <ElixirBenchLogo /> }
        >
          Start
        </Button>
      </Grid>
    </Grid>
  </form>
)

export default compose(
  pure,
  withStyles(styles),
  reduxForm({
    form: 'scheduleJob',
    validate: reduxFormValidate({
      branch: {
        required: true
      },
      commit: {
        required: true,
      },
      repoSlug: {
         required: true,
      }
    })
  }),
)(ScheduleJobForm);
