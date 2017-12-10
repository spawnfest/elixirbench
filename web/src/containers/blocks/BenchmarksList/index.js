import React from 'react';
import { compose, pure } from 'recompose'
import { withStyles } from 'material-ui/styles';
import MuiList from 'material-ui/List'

import BenchmarkListItem from './BenchmarkListItem'
import styles from './styles'

const BenchmarksList = ({ benchmarks = [], onBenchmarkClick }) => (
  <MuiList>
    { benchmarks.map(benchmark => (
      <BenchmarkListItem
        key={ benchmark.name }
        benchmark={ benchmark }
        onClick={ onBenchmarkClick }
      />
    ))}
  </MuiList>
)

export default compose(
  pure,
  withStyles(styles)
)(BenchmarksList);
