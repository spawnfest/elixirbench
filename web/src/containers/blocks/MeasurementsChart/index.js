import React from 'react';
import { map } from 'lodash'
import { compose, pure,withPropsOnChange } from 'recompose'
import { withStyles } from 'material-ui/styles'
import * as d3 from 'd3'
import { parse as parseDate } from 'date-fns'

import {
  ResponsiveContainer, ComposedChart,
  XAxis, YAxis, Tooltip, Legend,
} from 'recharts'

import styles from './styles'


var formatMinute = d3.timeFormat("%I:%M"),
    formatHour = d3.timeFormat("%I %p"),
    formatDay = d3.timeFormat("%a %d"),
    formatWeek = d3.timeFormat("%b %d"),
    formatMonth = d3.timeFormat("%B"),
    formatYear = d3.timeFormat("%Y");

function multiFormat(date) {
  return (d3.timeHour(date) < date ? formatMinute
      : d3.timeDay(date) < date ? formatHour
      : d3.timeMonth(date) < date ? (d3.timeWeek(date) < date ? formatDay : formatWeek)
      : d3.timeYear(date) < date ? formatMonth
      : formatYear)(date);
}

function formatXAxis(dateStr) {
  return multiFormat(parseDate(dateStr))
}

const MeasurementsChart = ({
  classes,
  measurements = [],
  children,
  dataKeys = []
}) => (
  <ResponsiveContainer width="100%" height={ 300 }>
    <ComposedChart data={ measurements }>
      <XAxis dataKey="collectedAt" tickFormatter={formatXAxis} />
      <YAxis domain={[0, 'auto']}  />
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
