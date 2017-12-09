defmodule ElixirBench.Benchmarks.Measurement do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirBench.Benchmarks.{Benchmark, Measurement}

  schema "measurements" do
    field :collected_at, :utc_datetime
    belongs_to :benchmark, Benchmark

    field :commit_sha, :string
    field :commit_message, :string
    field :commited_date, :utc_datetime
    field :commit_url, :string

    field :elixir_version, :string
    field :erlang_version, :string
    field :dependency_versions, {:map, :string}
    field :cpu, :string
    field :cpu_count, :integer
    # in mb
    field :memory, :integer

    field :sample_size, :integer

    field :mode, :float
    field :minimum, :float
    field :median, :float
    field :maximum, :float
    field :average, :float
    field :std_dev, :float
    field :std_dev_ratio, :float

    field :ips, :float
    field :std_dev_ips, :float

    field :run_times, {:array, :float}
    field :percentiles, {:map, :float}

    timestamps(type: :utc_datetime)
  end

  @fields [
    :collected_at,
    :commit_sha,
    :commit_message,
    :commited_date,
    :commit_url,
    :elixir_version,
    :erlang_version,
    :dependency_versions,
    :cpu,
    :cpu_count,
    :memory,
    :sample_size,
    :mode,
    :minimum,
    :maximum,
    :average,
    :std_dev,
    :std_dev_ratio,
    :ips,
    :std_dev_ips,
    :run_times,
    :percentiles
  ]

  @doc false
  def changeset(%Measurement{} = measurement, attrs) do
    measurement
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
