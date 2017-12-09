defmodule ElixirBenchWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :package do
    field :name, :string
    field :benchmarks, list_of(:benchmark)
  end

  object :benchmark do
    field :name, :string
    field :measurements, list_of(:measurement)
  end

  object :measurement do
    field :collected_at, :datetime
    field :commit, :commit
    field :environment, :environment
    field :result, :result
  end

  object :commit do
    field :sha, :string
    field :message, :string
    field :commited_date, :datetime
    field :url, :string
  end

  object :environment do
    field :elixir_version, :string
    field :erlang_version, :string
    field :dependency_versions, list_of(:package_version)
    field :cpu, :string
    field :cpu_count, :integer
    field :memory, :integer
  end

  object :package_version do
    field :name, :string
    field :version, :string
  end

  object :result do
    field :sample_size, :integer
    field :percentiles, list_of(:percentile)

    field :mode, :float
    field :minimum, :float
    field :median, :float
    field :maximum, :float
    field :average, :float
    field :std_dev, :float
    field :std_dev_ratio, :float

    field :ips, :float
    field :std_dev_ips, :integer

    field :run_times, list_of(:float)
  end

  object :percentile do
    field :name, :float
    field :value, :float
  end
end
