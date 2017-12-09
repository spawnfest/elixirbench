defmodule ElixirBench.Repo do
  use Ecto.Repo, otp_app: :elixir_bench

  def fetch(queryable, opts \\ []) do
    case one(queryable, opts) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
