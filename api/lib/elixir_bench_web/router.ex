defmodule ElixirBenchWeb.Router do
  use ElixirBenchWeb, :router

  alias ElixirBench.Benchmarks

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :runner_secure do
    plug BasicAuth, callback: &__MODULE__.authenticate_runner/3
  end

  scope "/api", ElixirBenchWeb do
    pipe_through [:api, :runner_secure]

    post "/jobs/claim", JobController, :claim
    put "/jobs/:id", JobController, :update
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ElixirBenchWeb.Schema

    forward "/", Absinthe.Plug, schema: ElixirBenchWeb.Schema
  end

  def authenticate_runner(conn, username, password) do
    case Benchmarks.authenticate_runner(username, password) do
      {:ok, runner} ->
        assign(conn, :runner, runner)
      {:error, _reason} ->
        send_resp(conn, :unauthorized, Antidote.encode!(%{error: "unauthorized"}))
    end
  end
end
