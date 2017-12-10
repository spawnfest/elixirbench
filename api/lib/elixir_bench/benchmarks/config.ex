defmodule ElixirBench.Benchmarks.Config do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirBench.Benchmarks.Config

  @primary_key false

  embedded_schema do
    field :elixir, :string, default: "1.5.2"
    field :erlang, :string, default: "20.1.2"
    field :environment, {:map, :string}, default: %{}
    embeds_one :deps, Dep, primary_key: false do
      embeds_many :docker, Docker, primary_key: {:image, :string, []} do
        field :container_name, :string
        field :environment, {:map, :string}, default: %{}
      end
    end
  end

  def changeset(%Config{} = config, attrs) do
    config
    |> cast(attrs, [:elixir, :erlang, :environment])
    |> validate_inclusion(:elixir, ["1.5.2"])
    |> validate_inclusion(:erlang, ["20.1.2"])
    |> cast_embed(:deps, with: &deps_changeset/2)
  end

  defp deps_changeset(deps, attrs) do
    deps
    |> cast(attrs, [])
    |> cast_embed(:docker, with: &docker_changeset/2)
  end

  defp docker_changeset(docker, attrs) do
    docker
    |> cast(attrs, [:image, :container_name, :environment])
    |> validate_required([:image])
  end
end
