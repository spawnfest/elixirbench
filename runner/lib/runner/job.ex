defmodule ElixirBench.Command do
  def run(command, args, opts \\ []) when is_binary(command) and is_list(args) do
    assert_no_null_byte!(command, "System.cmd/3")
    cmd = String.to_charlist(command)
    cmd =
      if Path.type(cmd) == :absolute do
        cmd
      else
        :os.find_executable(cmd) || :erlang.error(:enoent, [command, args, opts])
      end
    {into, stdin, opts} = cmd_opts(opts, [:use_stdio, :exit_status, :binary, :hide, args: args], "", "")
    {initial, fun} = Collectable.into(into)
    try do
      port = Port.open({:spawn_executable, cmd}, opts)
      if stdin != "", do: Port.command(port, stdin)
      do_cmd port, initial, fun
    catch
      kind, reason ->
        stacktrace = System.stacktrace
        fun.(initial, :halt)
        :erlang.raise(kind, reason, stacktrace)
    else
      {acc, status} -> {fun.(acc, :done), status}
    end
  end
  defp do_cmd(port, acc, fun) do
    receive do
      {^port, {:data, data}} ->
        do_cmd(port, fun.(acc, {:cont, data}), fun)
      {^port, {:exit_status, status}} ->
        {acc, status}
    end
  end
  defp cmd_opts([{:into, any} | t], opts, stdin, _into),
    do: cmd_opts(t, opts, stdin, any)
  defp cmd_opts([{:cd, bin} | t], opts, stdin, into) when is_binary(bin),
    do: cmd_opts(t, [{:cd, bin} | opts], stdin, into)
  defp cmd_opts([{:arg0, bin} | t], opts, stdin, into) when is_binary(bin),
    do: cmd_opts(t, [{:arg0, bin} | opts], stdin, into)
  defp cmd_opts([{:stderr_to_stdout, true} | t], opts, stdin, into),
    do: cmd_opts(t, [:stderr_to_stdout | opts], stdin, into)
  defp cmd_opts([{:stderr_to_stdout, false} | t], opts, stdin, into),
    do: cmd_opts(t, opts, stdin, into)
  defp cmd_opts([{:parallelism, bool} | t], opts, stdin, into) when is_boolean(bool),
    do: cmd_opts(t, [{:parallelism, bool} | opts], stdin, into)
  defp cmd_opts([{:env, enum} | t], opts, stdin, into),
    do: cmd_opts(t, [{:env, validate_env(enum)} | opts], stdin, into)

  defp cmd_opts([{:stdin, stdin} | t], opts, _stdin, into) when is_binary(stdin),
    do: cmd_opts(t, opts, stdin, into)
  defp cmd_opts([{key, val} | _], _opts, _stdin, _into),
    do: raise(ArgumentError, "invalid option #{inspect key} with value #{inspect val}")
  defp cmd_opts([], opts, stdin, into),
    do: {into, stdin, opts}
  defp validate_env(enum) do
    Enum.map enum, fn
      {k, nil} ->
        {String.to_charlist(k), false}
      {k, v} ->
        {String.to_charlist(k), String.to_charlist(v)}
      other ->
        raise ArgumentError, "invalid environment key-value #{inspect other}"
    end
  end


  defp assert_no_null_byte!(binary, operation) do
    case :binary.match(binary, "\0") do
      {_, _} ->
        raise ArgumentError, "cannot execute #{operation} for program with null byte, got: #{inspect binary}"
      :nomatch ->
        binary
    end
  end
end

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

      {log, exit_code} = ElixirBench.Command.run("docker-compose", ["-f", compose_config_path] ++ @static_docker_compose_args)

      IO.puts log
    end
  end

  defp dep_name_from_image(image) do
    [slug | _tag] = String.split(image, ":")
    slug |> String.split("/") |> List.last()
  end
end
