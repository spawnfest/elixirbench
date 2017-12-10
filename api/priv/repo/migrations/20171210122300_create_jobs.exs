defmodule ElixirBench.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def up do
    create table(:jobs) do
      add :repo_id, references(:repos), null: false

      add :claimed_by, references(:runners)
      add :claimed_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :log, :text

      add :branch_name, :string
      add :commit_sha, :string
      add :commit_message, :string
      add :commit_url, :string
      add :elixir_version, :string
      add :erlang_version, :string
      add :dependency_versions, :map
      add :cpu, :string
      add :cpu_count, :integer
      add :memory_mb, :integer

      timestamps()
    end

    alter table(:measurements) do
      remove :collected_at
      remove :commit_sha
      remove :commit_message
      remove :commit_url
      remove :elixir_version
      remove :erlang_version
      remove :dependency_versions
      remove :cpu
      remove :cpu_count
      remove :memory

      add :job_id, references(:jobs), null: false
    end

    create index(:jobs, [:repo_id])
    create index(:jobs, [:claimed_by])
    create index(:jobs, [:completed_at])
    create index(:measurements, [:job_id])
  end

  def down do
    drop table(:jobs)

    drop index(:measurements, [:job_id])

    alter table(:measurements) do
      remove :job_id

      add :collected_at, :utc_datetime
      add :commit_sha, :string
      add :commit_message, :string
      add :commit_url, :string
      add :elixir_version, :string
      add :erlang_version, :string
      add :dependency_versions, :map
      add :cpu, :string
      add :cpu_count, :integer
      add :memory, :integer
    end
  end
end
