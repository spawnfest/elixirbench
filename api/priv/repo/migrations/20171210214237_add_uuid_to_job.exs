defmodule ElixirBench.Repo.Migrations.AddUuidToJob do
  use Ecto.Migration

  def change do
    execute """
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    """, "" # nothing on down

    alter table(:jobs) do
      add :uuid, :uuid, null: false, default: fragment("uuid_generate_v4()")
    end
  end
end
