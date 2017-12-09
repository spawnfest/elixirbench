import React from 'react';
import { compose, pure } from 'recompose'

const IndexPage = () => (
  <div className="App">
    <header className="App-header">
      <h1 className="App-title">Welcome to ElixirChain</h1>
    </header>
    <p className="App-intro"></p>
  </div>
)

export default compose(
  pure
)(IndexPage);
