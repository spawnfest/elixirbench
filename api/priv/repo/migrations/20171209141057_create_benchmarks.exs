defmodule ElixirBench.Repo.Migrations.CreateBenchmarks do
  use Ecto.Migration

  def change do
    create table(:benchmarks) do
      add :repo_id, references(:repos), null: false
      add :name, :string

      timestamps()
    end

    create unique_index(:benchmarks, [:repo_id, :name])
  end
end
