defmodule ElixirBench.Benchmarks do
  import Ecto
  import Ecto.Query, warn: false
  alias ElixirBench.Repo
  alias Ecto.Multi

  alias ElixirBench.Github
  alias ElixirBench.Repos
  alias ElixirBench.Benchmarks.{Benchmark, Measurement, Job, Runner, Config}

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Benchmark, %{repo_id: repo_id}) do
    from b in Benchmark, where: b.repo_id == ^repo_id
  end

  def query(queryable, _args) do
    queryable
  end

  def create_runner(attrs) do
    %Runner{}
    |> Runner.changeset(attrs)
    |> Repo.insert()
  end

  def fetch_benchmark(repo_id, name) do
    Repo.fetch(where(Benchmark, repo_id: ^repo_id, name: ^name))
  end

  def fetch_measurement(id) do
    Repo.fetch(where(Measurement, id: ^id))
  end

  def list_benchmarks_by_repo_id(repo_ids) do
    Repo.all(from(b in Benchmark, where: b.repo_id in ^repo_ids))
  end

  def create_job(%Repos.Repo{} = repo, attrs) do
    changeset = Job.create_changeset(%Job{repo_id: repo.id}, attrs)
    with {:ok, job} <- Ecto.Changeset.apply_action(changeset, :insert),
         {:ok, raw_config} <- Github.fetch_config(repo.owner, repo.name, job.commit_sha) do
      config_changeset = Config.changeset(%Config{}, raw_config)
      changeset
      |> Ecto.Changeset.put_embed(:config, config_changeset)
      |> Repo.insert()
    end
  end

  def claim_job(%Runner{} = runner) do
    Repo.transaction(fn ->
      with {:ok, job} <- fetch_unclaimed_job() do
        changeset = Job.claim_changeset(job, runner.id)
        Repo.update!(changeset)
      else
        {:error, error} -> Repo.rollback(error)
      end
    end)
  end

  def submit_job(%Job{} = job, results) do
    multi = Multi.update(Multi.new(), :job, Job.submit_changeset(job, results))

    multi =
      Enum.reduce(results["measurements"] || [], multi, fn {name, result}, multi ->
        benchmark = {:benchmark, name}

        multi
        |> Multi.run(benchmark, fn _ ->
             {:ok, get_or_create_benchmark!(job.repo_id, name)}
           end)
        |> Multi.run({:measurement, name}, fn %{^benchmark => benchmark} ->
             create_measurement(benchmark, job, result)
           end)
      end)

    case Repo.transaction(multi) do
      {:ok, _} -> :ok
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  defp get_or_create_benchmark!(repo_id, name) do
    # We need to set something on_conflict, otherwise, we won't be able to get the id
    # of already existing result in returning
    updates = [updated_at: DateTime.utc_now()]
    opts = [on_conflict: [set: updates], conflict_target: [:repo_id, :name], returning: true]
    Repo.insert!(%Benchmark{repo_id: repo_id, name: name}, opts)
  end

  defp create_measurement(%Benchmark{} = bench, %Job{} = job, attrs) do
    build_assoc(bench, :measurements, job_id: job.id)
    |> Measurement.changeset(attrs)
    |> Repo.insert()
  end

  defp fetch_unclaimed_job() do
    Repo.fetch(from j in Job,
      where: is_nil(j.claimed_by) and is_nil(j.claimed_at) and is_nil(j.completed_at),
      lock: "FOR UPDATE SKIP LOCKED",
      limit: 1
    )
  end
end
