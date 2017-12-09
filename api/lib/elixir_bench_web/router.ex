defmodule ElixirBenchWeb.Router do
  use ElixirBenchWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ElixirBenchWeb.Schema

    forward "/", Absinthe.Plug, schema: ElixirBenchWeb.Schema
  end
end
