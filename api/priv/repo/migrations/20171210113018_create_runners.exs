defmodule ElixirBench.Repo.Migrations.CreateRunners do
  use Ecto.Migration

  def change do
    create table(:runners) do
      add :name, :string
      add :api_key_hash, :string

      timestamps()
    end

  end
end
