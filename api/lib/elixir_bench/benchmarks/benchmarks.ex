defmodule ElixirBench.Benchmarks do
  import Ecto
  import Ecto.Query, warn: false
  alias ElixirBench.Repo

  alias ElixirBench.Benchmarks.{Benchmark, Measurement}

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Benchmark, %{repo_id: repo_id}) do
    from b in Benchmark, where: b.repo_id == ^repo_id
  end

  def query(Measurement, _args) do
    from m in Measurement, order_by: m.collected_at
  end

  def get_or_create_benchmark!(repo_id, name) do
    # We need to set something on_conflict, otherwise, we won't be able to get the id
    # of already existing result
    opts = [on_conflict: [set: [name: name]], conflict_target: [:repo_id, :name], returning: true]
    Repo.insert!(%Benchmark{repo_id: repo_id, name: name}, opts)
  end

  def list_benchmarks_by_repo_id(repo_ids) do
    Repo.all(from b in Benchmark, where: b.repo_id in ^repo_ids)
  end

  def create_measurement(%Benchmark{} = bench, attrs \\ %{}) do
    build_assoc(bench, :measurements)
    |> Measurement.changeset(attrs)
    |> Repo.insert()
  end

  def update_measurement(%Measurement{} = measurement, attrs) do
    measurement
    |> Measurement.changeset(attrs)
    |> Repo.update()
  end

  def delete_measurement(%Measurement{} = measurement) do
    Repo.delete(measurement)
  end
end
