

defmodule ElixirBench.Runner.Job do
  alias ElixirBench.Runner.Config

  defstruct id: nil, config: %ElixirBench.Runner.Config{}, log: nil, results: nil, containers: []

  @static_docker_compose_args ~w[up --force-recreate --no-build --abort-on-container-exit --remove-orphans]

  # TODO: We need to clean docker cache after each run, to don't blow up VM disk
  def start_job(id, repo_slug, branch, commit) do
    # TODO: Ensure no jobs are running
    with {:ok, config} <- Config.fetch_config_by_repo_slug(repo_slug, commit) do
      benchmarking_results_path = Confex.fetch_env!(:runner, :benchmarking_results_path)
      container_benchmarking_results_path = Confex.fetch_env!(:runner, :container_benchmarking_results_path)
      volume_mount = "#{benchmarking_results_path}/#{id}"
      File.mkdir_p!(volume_mount)

      runner_env =
        config.environment_variables
        |> Map.put("ELIXIRBENCH_REPO_SLUG", repo_slug)
        |> Map.put("ELIXIRBENCH_REPO_BRANCH", branch)
        |> Map.put("ELIXIRBENCH_REPO_COMMIT", commit)

      services =
        config.deps
        |> Enum.reduce(%{}, fn dep, services ->
          default_name =
            dep
            |> Map.fetch!("image")
            |> dep_name_from_image()

          name = Map.get(dep, "container_name", default_name)

          Map.put(services, name, dep)
        end)

      services =
        Map.put(services, "runner", %{
          image: "elixirbench/#{config.elixir_version}-#{config.erlang_version}",
          volumes: ["#{volume_mount}:#{container_benchmarking_results_path}"],
          links: Map.keys(services),
          environment: runner_env
        })

      compose_config = Antidote.encode!(%{version: "3", services: services})
      compose_config_path = "#{benchmarking_results_path}/#{id}-config.yml"
      File.write!(compose_config_path, compose_config)

      IO.inspect services

      {log, exit_code} = System.cmd("docker-compose", ["-f", compose_config_path] ++ @static_docker_compose_args)

      IO.puts log
    end
  end

  defp dep_name_from_image(image) do
    [slug | _tag] = String.split(image, ":")
    slug |> String.split("/") |> List.last()
  end
end
