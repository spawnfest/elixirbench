defmodule ElixirBenchWeb.Schema do
  use Absinthe.Schema

  alias ElixirBenchWeb.Schema

  alias ElixirBench.{Repos, Benchmarks}

  import_types Absinthe.Type.Custom
  import_types Schema.ContentTypes

  query do
    field :repos, list_of(:repo) do
      resolve fn _, _ ->
        {:ok, Repos.list_repos()}
      end
    end

    field :repo, non_null(:repo) do
      arg :slug, non_null(:string)
      resolve fn %{slug: slug}, _b ->
        Repos.get_repo_by_slug(slug)
      end
    end
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Benchmarks, Benchmarks.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
