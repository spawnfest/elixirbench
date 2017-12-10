<img src="../web/public/images/logo.png" height="68" />

# ElixirBench Runner

This is an Elixir daemon that pulls for job our API and executes tests in `runner-container`.

## Dependencies

Benchmarks are running inside a docker container, so you need to have
[`docker`](https://docs.docker.com/engine/installation/) and
[`docker-compose`](https://docs.docker.com/compose/install/) installed.

## Deployment

To build the release you can use `mix release`. The relese requires a `RUNNER_API_KEY` and `RUNNER_API_USER`
environment variables for communication with the API server.
