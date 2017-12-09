defmodule ElixirBench.Repos.Repo do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirBench.Repos.Repo


  schema "repos" do
    field :name, :string
    field :owner, :string

    timestamps()
  end

  @doc false
  def changeset(%Repo{} = repo, attrs) do
    repo
    |> cast(attrs, [:owner, :name])
    |> validate_required([:owner, :name])
  end
end
