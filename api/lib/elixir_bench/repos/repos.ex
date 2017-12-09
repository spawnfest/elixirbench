defmodule ElixirBench.Repos do
  import Ecto.Query, warn: false
  alias ElixirBench.Repo

  alias ElixirBench.Repos

  def list_repos() do
    Repo.all(Repos.Repo)
  end

  def get_repo_by_slug(slug) do
    with [owner, name] <- String.split(slug, "/", parts: 2) do
      query = where(Repos.Repo, [owner: ^owner, name: ^name])
      Repo.fetch(query)
    else
      _ -> {:error, :invalid_slug}
    end
  end

  def create_repo(attrs \\ %{}) do
    %Repos.Repo{}
    |> Repos.Repo.changeset(attrs)
    |> Repo.insert()
  end

  def update_repo(%Repos.Repo{} = repo, attrs) do
    repo
    |> Repos.Repo.changeset(attrs)
    |> Repo.update()
  end

  def delete_repo(%Repos.Repo{} = repo) do
    Repo.delete(repo)
  end
end
