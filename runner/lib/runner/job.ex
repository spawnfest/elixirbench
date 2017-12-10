defmodule ElixirBench.Runner.Job do
  @moduledoc """
  This module is responsible for starting and halting jobs.

  Under the hood it's using CLI integration to docker-compose.
  """
  alias ElixirBench.Runner.{Job, Config}

  defstruct id: nil,
            repo_slug: nil,
            branch: nil,
            commit: nil,
            config: %Config{},
            status: nil,
            log: nil,
            context: %{},
            measurements: %{}

  # --force-recreate -          Recreate containers even if their configuration and image haven't changed;
  # --no-build -                We don't allow users to use our benchmarking service to build images,
  #                             TODO: warn when `build` config key is present in docker deps;
  # --abort-on-container-exit - Stops all containers when one of them exists,
  #                             this allows us to shut down all deps when benchmarks are completed;
  # --remove-orphans -          Remove containers for services not defined in the Compose file.
  @static_compose_args ~w[up --force-recreate --no-build --abort-on-container-exit --remove-orphans]

  # Both host and container:runner network modes are allowing
  # to use localhost for sending requests to a helper container,
  # with following cons:
  # * `container:runner` network mode violates start order,
  # so runner is started before DB's, but source pooling saves the day;
  # * `host` binds to all host interfaces, which is not best for
  # security but gives better performance.
  @network_mode "host"

  @doc """
  Executes a benchmarking job for a specific commit.
  """
  def start_job(id, repo_slug, branch, commit, config) do
    ensure_no_other_jobs!()

    job = %Job{id: to_string(id), repo_slug: repo_slug, branch: branch, commit: commit, config: config}

    task =
      Task.Supervisor.async_nolink(ElixirBench.Runner.JobsSupervisor, fn ->
        run_job(job)
      end)

    timeout = Confex.fetch_env!(:runner, :job_timeout)
    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, result} -> result

      nil ->
        %{job | status: 127, log: "Job execution timed out"}
    end
  end

  defp ensure_no_other_jobs! do
    %{active: 0} = Supervisor.count_children(ElixirBench.Runner.JobsSupervisor)
  end

  @doc false
  # Public for testing purposes
  def run_job(job) do
    benchmars_output_path = get_benchmars_output_path(job)
    File.mkdir_p!(benchmars_output_path)

    compose_config = get_compose_config(job)
    compose_config_path = "#{benchmars_output_path}/#{job.id}-config.yml"
    File.write!(compose_config_path, compose_config)

    try do
      {log, status} = System.cmd("docker-compose", ["-f", compose_config_path] ++ @static_compose_args)
      measurements = collect_measurements(benchmars_output_path)
      context = collect_context(benchmars_output_path)
      %{job | log: log, status: status, measurements: measurements, context: context}
    after
      # Stop all containers and delete all containers, images and build cache
      # {_log, 0} = System.cmd("docker", ~w[system prune -a -f])

      # Clean benchmarking temporary files
      File.rm_rf!(benchmars_output_path)
    end
  end

  defp get_benchmars_output_path(%Job{id: id}) do
    Confex.fetch_env!(:runner, :benchmars_output_path) <> "/" <> id
  end

  defp get_compose_config(job) do
    Antidote.encode!(%{version: "3", services: build_services(job)})
  end

  defp build_services(job) do
    %{id: id, config: config} = job

    services =
      config.deps
      |> Enum.reduce(%{}, fn dep, services ->
        dep = Map.put(dep, "network_mode", @network_mode)
        name = "job_" <> id <> "_" <> get_dep_container_name(dep)
        Map.put(services, name, dep)
      end)

    Map.put(services, "runner", build_runner_service(job, Map.keys(services)))
  end

  defp get_dep_container_name(%{"container_name" => container_name}), do: container_name
  defp get_dep_container_name(%{"image" => image}), do: dep_name_from_image(image)

  defp build_runner_service(job, deps) do
    container_benchmars_output_path = Confex.fetch_env!(:runner, :container_benchmars_output_path)

    %{
        network_mode: @network_mode,
        image: "elixirbench/runner:#{job.config.elixir_version}-#{job.config.erlang_version}",
        volumes: ["#{get_benchmars_output_path(job)}:#{container_benchmars_output_path}:Z"],
        depends_on: deps,
        environment: build_runner_environment(job)
      }
  end

  defp build_runner_environment(job) do
    %{repo_slug: repo_slug, branch: branch, commit: commit, config: config} = job

    config.environment_variables
    |> Map.put("ELIXIRBENCH_REPO_SLUG", repo_slug)
    |> Map.put("ELIXIRBENCH_REPO_BRANCH", branch)
    |> Map.put("ELIXIRBENCH_REPO_COMMIT", commit)
  end

  defp dep_name_from_image(image) do
    [slug | _tag] = String.split(image, ":")
    slug |> String.split("/") |> List.last()
  end

  defp collect_measurements(benchmars_output_path) do
    "#{benchmars_output_path}/*.json"
    |> Path.wildcard()
    |> Enum.flat_map(fn path ->
      benchmark_name = Path.basename(path, ".json")
      path |> File.read!() |> Antidote.decode!() |> format_measurement(benchmark_name)
    end)
  end

  defp format_measurement(measurement, benchmark_name) do
    run_times = Map.get(measurement, "run_times")
    statistics = Map.get(measurement, "statistics")

    Map.new(run_times, fn {name, runs} ->
      data = Map.fetch!(statistics, name)
      data = Map.put(data, :run_times, runs)
      {benchmark_name <> "/" <> name, data}
    end)
  end

  defp collect_context(benchmars_output_path) do
    mix_deps = read_mix_deps("#{benchmars_output_path}/mix.lock")

    %{
      dependency_versions: mix_deps,
      cpu_count: Benchee.System.num_cores(),
      worker_os: Benchee.System.os(),
      memory: Benchee.System.available_memory(),
      cpu: Benchee.System.cpu_speed()
    }
  end

  def read_mix_deps(file) do
    case File.read(file) do
      {:ok, info} ->
        case Code.eval_string(info, [], file: file) do
          {lock, _binding} when is_map(lock) ->
            Map.new(lock, fn
              {dep_name, ast} when elem(ast, 0) == :git ->
                {dep_name, elem(ast, 1)}

              {dep_name, ast} when elem(ast, 0) == :hex ->
                {dep_name, elem(ast, 2)}

              {dep_name, ast} when elem(ast, 0) == :path ->
                {dep_name, elem(ast, 1)}
            end)

          {_, _binding} ->
            %{}
        end
      {:error, _} ->
        %{}
    end
  end
end
