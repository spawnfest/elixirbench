defmodule ElixirBenchWeb.Schema do
  use Absinthe.Schema

  alias ElixirBenchWeb.Schema

  import_types Absinthe.Type.Custom
  import_types Schema.ContentTypes

  query do
    field :repos, list_of(:repo) do
      resolve fn _, _, _ -> {:ok, []} end
    end
  end
end
