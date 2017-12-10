defmodule ElixirBench.Runner do
  use GenServer
  require Logger

  alias ElixirBench.Runner.{Api, Job, Config}

  @claim_delay 10_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(_opts) do
    Process.send_after(self(), :try_claim, @claim_delay)
    client = %Api.Client{username: Confex.fetch_env!(:runner, :api_user), password: Confex.fetch_env!(:runner, :api_key)}
    {:ok, client}
  end

  def handle_info(:try_claim, client) do
    case Api.claim_job(client) do
      {:ok, %{"data" => %{"id" => id} = job}} ->
        Logger.info("Claimed job:#{id}")
        process_job(job, client)

      {:error, reason} ->
        Logger.info("Failed to claim job: #{inspect(reason)}")
    end

    Process.send_after(self(), :try_claim, @claim_delay)
    {:noreply, client}
  end

  defp process_job(job, client) do
    %{"id" => id, "repo_slug" => repo_slug, "branch_name" => branch, "commit_sha" => commit, "config" => config} = job
    config = Config.from_string_map(config)
    job = Job.start_job(id, repo_slug, branch, commit, config)
    data = %{
      elixir_version: job.config.elixir_version,
      erlang_version: job.config.erlang_version,
      measurements: job.measurements,
      log: job.log || ""
    }
    data = Map.merge(data, job.context)
    {:ok, _} = Api.submit_results(client, job, data)
  end
end
