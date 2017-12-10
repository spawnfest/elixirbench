defmodule ElixirBench.Benchmarks.Measurement do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirBench.Benchmarks.{Benchmark, Job, Measurement}

  schema "measurements" do
    belongs_to :benchmark, Benchmark
    belongs_to :job, Job

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
