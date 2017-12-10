defmodule ElixirBench.Repo.Migrations.AddConfigToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :config, :map
    end
  end
end
