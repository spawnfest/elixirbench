<img src="./web/public/images/logo.png" height="68" />

# ElixirBench

Long Running Benchmarks for Elixir Projects.

## Goal

The primary goal of ElixirBench is to improve the Elixir and Erlang ecosystem of open source libraries.

We're maintainers of couple open source packages, and we know how difficult it sometimes is,
to guard against performance regressions. While test suites are popular, benchmark suites are not -
which is a great shame. Poor performace is a bug like every other yet it is often overlooked.

To solve this problem, we decided to create this project that will help mainainers of
libraries in providing consistent performance of their code through constant monitoring.

The project is inspired by similar projects from other ecosystems:
  * https://rubybench.org/
  * https://speed.python.org/
  * https://perf.rust-lang.org/

Unlike those projects, though, that are focused on some fixed packages, ElixirBench looks to
provide a common service, similar to a continuous integration system, available for all packages
published on Hex.

## Implementation

The project consists of several components:

* [the API server](api/) - powers everything and is responsible for scheduling execution of
  benchmarks. The server provides a public GraphQL API for exploring the results of the
  benchmarks and a private JSON API for communication with the runner server.
* [the runner server](runner/) - runs on separate infrastructure and is responsible for consistent
  execution of benchmarks.
* [the runner container](runner-container/) - scripts to build docker container which fetches project
  source and executes benchmarks.
* [the front-end](web/) - is a website that leverages the GraphQL API and facilitates exploration
  of the results..

## How to use it

To leverage ElixirBench in a project, a YAML configuration file is expected in `bench/config.yml`
in the project's Githib repository.
This configuration file specifies the environment for running the benchmark. Additional services,
like databases can be provisioned through docker containers.

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

Right now, only one benchmark runner is supported - the [`benchee`](https://github.com/PragTob/benchee) package.
The runner, once the whole environment is brought up, will invoke a single command to run the benchmarks:
```
mix run benches/bench_helper.exs
```
This script is responsible for setup, execution and cleanup of benchmarks.
Results of the runs, should be stored in JSON format in the directory indicated by the
`BENCHMARKS_OUTPUT_PATH` environment variable. An example benchmark can be found in the
[Ecto repository](https://github.com/elixir-ecto/ecto/blob/00284340a69f4cb5327323f12e37c98a81208279/bench/insert_bench.exs).

In the future, we expect to establish a common file format for results and support multiple
benchmark runners for mix and rebar projects.

### Running benchmarks

Benchmarking UI is available on the [official website](http://www.elixirbench.org/).

In the future, benchmarks should be executed automatically through hooks on repositories whenever
new code is pushed. Right now, a manual scheduling of runs is required. This can be done in the
[GraphiQL](https://api.elixirbench.org/api/graphiql) API explorer by issuing a mutation:
```graphql
mutation {
  scheduleJob(repoSlug: "elixir-ecto/ecto", branchName: "mm/benches", commitSha: "2a5a8efbc3afee3c6893f4cba33679e98142df3f") {
    id
  }
}
```
The above branch and commit contain a valid sample benchmark.

## Future development

- Improve test coverage;
- Foolproof agains common errors;
- Investigate security of worker docker containers;
- Create a GitHub marketplace app that would ease integration to the level of most common CI tools;
- Automatic running of benchmarks through repository hooks;
- More benchmark tools which are easier to use and require less manual setup - maybe some generators;
- Also, it would be awesome to have integration with GitHub PR check's, so that maintainers can keep track how each PR affects library performance. If we would not be able to handle heavy load because of all that jobs - we can white-list most common packages and give it's developers lightweight version or PR checks - to request to run some commit from another fork/branch to compare how it works before merging it;
- Provide reliable servers. Since we're running benchmarks, cloud server providers are not
  appropriate because of the noisy neighbour problem. Some dedicated servers would be required
  for running the benchmarks.
