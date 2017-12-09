defmodule ElixirBenchWeb.Router do
  use ElixirBenchWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirBenchWeb do
    pipe_through :api
  end
end
