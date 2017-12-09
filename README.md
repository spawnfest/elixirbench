# ElixirBench

Long Running Benchmarks for Elixir Projects

## Goal

Aid mainainers of open source libraries in providing consistent performance of their
applications and libraries through constant monitoring.

The project is inspired by similar projects:
  * https://rubybench.org/
  * https://speed.python.org/
  * https://perf.rust-lang.org/

## Implementation

The project consists of several components:

* the API server - powers everything and is responsible for scheduling execution of
  benchmarks. The server provides a public GraphQL API for exploring the results of the
  benchmarks.
* the runner server - runs on separate infrastructure and is responsible for consistent
  execution of benchmarks.
* the front-end - is a website that leverages the GraphQL API and  facilitates exploration
  of the results for humans.
