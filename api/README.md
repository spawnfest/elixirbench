<img src="../web/public/images/logo.png" height="68" />

# ElixirBench API

This project provides a public GraphQL API for exploring the results of the
benchmarks and is responsible for jobs scheduling.

You can explore it's API doc in public [GraphiQL](https://api.elixirbench.org/api/graphiql)
interface.

## Requirements

The projects needs Erlang, Elixir and PostgreSQL installed.

For development, a database user called `postgress` with password `postgress` is required.
If desired otherwise, this configuration can be changed in `config/dev.exs`.

## Getting started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Set up the database and some sample seed data `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) from your browser.

## Deployment

To build the release you can use `mix release`. The relese requires a `PORT` environment variable.
