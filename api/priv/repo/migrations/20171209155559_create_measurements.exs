defmodule ElixirBench.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :collected_at, :utc_datetime
      add :commit_sha, :string
      add :commit_message, :text
      add :commited_date, :utc_datetime
      add :commit_url, :string

      add :elixir_version, :string
      add :erlang_version, :string
      add :dependency_versions, :map
      add :cpu, :string
      add :cpu_count, :integer
      add :memory, :integer

      add :sample_size, :integer

      add :mode, :float
      add :minimum, :float
      add :median, :float
      add :maximum, :float
      add :average, :float
      add :std_dev, :float
      add :std_dev_ratio, :float

      add :ips, :float
      add :std_dev_ips, :float

      add :run_times, {:array, :float}
      add :percentiles, :map

      add :benchmark_id, references(:benchmarks), null: false

      timestamps()
    end

    create index(:measurements, [:collected_at])
  end
end
