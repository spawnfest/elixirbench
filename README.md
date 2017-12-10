# ElixirBench

Long Running Benchmarks for Elixir Projects.

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
* the front-end - is a website that leverages the GraphQL API and facilitates exploration
  of the results for humans.

## How to use it

### Creating benchmarking suite

Maintainer should add YAML configuration file (similar to the ones that you would use for
configuring CI) to the `bench/config.yml`:

```yaml
elixir: 1.5.2
erlang: 20.1.2
environment:
  PG_URL: postgres:postgres@localhost
  MYSQL_URL: root@localhost
deps:
  docker:
    - container_name: postgres
      image: postgres:9.6.6-alpine
    - container_name: mysql
      image: mysql:5.7.20
      environment:
        MYSQL_ALLOW_EMPTY_PASSWORD: "true"
```

Along with this file there should be a bench suite, that uses
popular [`benchee`](https://github.com/PragTob/benchee) package.

You can find code sample in [Ecto repo](https://github.com/elixir-ecto/ecto/tree/mm/benches).

### Running benchmarks

Benchmarking UI is available on the [official website](https://spawnfest.github.io/elixirbench/#/).
