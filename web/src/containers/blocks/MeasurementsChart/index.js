import React from 'react';
import { map } from 'lodash'
import { compose, pure,withPropsOnChange } from 'recompose'
import { withStyles } from 'material-ui/styles';
import {
  ResponsiveContainer, ComposedChart,
  XAxis, YAxis, Tooltip, Legend,
} from 'recharts'

import styles from './styles'

const MeasurementsChart = ({
  classes,
  measurements = [],
  children,
  dataKeys = []
}) => (
  <ResponsiveContainer width="100%" height={ 300 }>
    <ComposedChart data={ measurements }>
      <XAxis dataKey="collectedAt" />
      <YAxis />
      <Tooltip />
      <Legend />
      { children }
    </ComposedChart>
  </ResponsiveContainer>
)

export default compose(
  pure,
  withStyles(styles),
  withPropsOnChange(
    ['measurements'],
    ({ measurements }) => ({
      measurements: map(measurements, i => ({
        ...i.result,
        collectedAt: i.collectedAt
      }))
    })
  )
)(MeasurementsChart);
