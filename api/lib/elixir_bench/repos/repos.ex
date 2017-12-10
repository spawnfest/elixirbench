defmodule ElixirBench.Repos do
  import Ecto.Query, warn: false
  alias ElixirBench.Repo

  alias ElixirBench.Repos

  def list_repos() do
    Repo.all(Repos.Repo)
  end

  def fetch_repo_by_slug(slug) do
    parse_slug(slug, fn owner, name ->
      Repo.fetch(where(Repos.Repo, [owner: ^owner, name: ^name]))
    end)
  end

  def fetch_repo(id) do
    Repo.fetch(where(Repos.Repo, id: ^id))
  end

  def fetch_repo_id_by_slug(slug) do
    parse_slug(slug, fn owner, name ->
      Repo.fetch(from r in Repos.Repo, where: [owner: ^owner, name: ^name], select: r.id)
    end)
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

  defp parse_slug(slug, callback) do
    case String.split(slug, "/", trim: true, parts: 2) do
      [owner, name] -> callback.(owner, name)
      _ -> {:error, :invalid_slug}
    end
  end
end
