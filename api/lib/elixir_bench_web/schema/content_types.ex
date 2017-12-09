defmodule ElixirBenchWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ElixirBench.Repo
  import Absinthe.Resolution.Helpers

  alias ElixirBench.Benchmarks

  object :repo do
    field :owner, :string
    field :name, :string
    field :slug, :string, resolve: fn repo, _args, _info -> {:ok, "#{repo.owner}/#{repo.name}"} end

    field :benchmarks, list_of(:benchmark) do
      resolve fn %{id: id}, _, _ ->
        batch({__MODULE__, :list_benchmarks_by_repo_id}, id, fn batch_results ->
          {:ok, Map.get(batch_results, id, [])}
        end)
      end
    end
  end

  object :benchmark do
    field :name, :string
    field :measurements, list_of(:measurement), resolve: assoc(:measurements)
  end

  object :measurement do
    field :collected_at, :datetime
    field :commit, :commit, resolve: parent()
    field :environment, :environment, resolve: parent()
    field :result, :result, resolve: parent()
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
    field :dependency_versions, list_of(:package_version),
      resolve: map_to_list(:dependency_versions, :name, :version)
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
    field :percentiles, list_of(:percentile), resolve: map_to_list(:percentiles, :name, :value)

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
    field :name, :string
    field :value, :float
  end

  defp parent() do
    fn parent, _, _ ->
      {:ok, parent}
    end
  end

  defp map_to_list(key, key_name, value_name) do
    fn %{^key => map}, _, _ ->
      {:ok, Enum.map(map, fn {key, value} -> %{key_name => key, value_name => value} end)}
    end
  end

  @doc false
  def list_benchmarks_by_repo_id(_, repo_ids) do
    data = Benchmarks.list_benchmarks_by_repo_id(repo_ids)
    Enum.group_by(data, &Map.fetch!(&1, :repo_id))
  end
end
