defmodule ElixirBench.Runner.ConfigParser do
  @moduledoc """
  This module is responsible for processing
  """

  @github_base_url "https://raw.githubusercontent.com/"

  @doc """
  Fetch config from a GitHub repo by it's slug.

  Right now It's only possible to fetch config from a public repo.
  """
  def fetch_config_by_repo_slug(repo_slug, branch \\ "") do
    repo_slug = String.trim(repo_slug, "/")
    branch = String.trim(branch, "/")
    url =
      if branch == "" do
        [@github_base_url, repo_slug, "/bench/config.yml"]
      else
        [@github_base_url, repo_slug, "/", branch, "/bench/config.yml"]
      end

    with {:ok, content} <- fetch_file_contents(url) do
      parse_yaml(content)
    end
  end

  defp fetch_file_contents(url) do
    headers = [{"accept", "application/json"}, {"content-type", "application/json"}]
    case :hackney.request(:get, url, headers, "", [:with_body]) do
      {:ok, status, _headers, ""} when status in 200..299 ->
        {:error, :no_content}
      {:ok, 404, _headers, _body} ->
        {:error, :config_not_found}
      {:ok, status, _headers, body} when status in 200..299 ->
        {:ok, body}
      {:ok, status, _headers, body} when status in 400..499 ->
        {:error, {status, body}}
      {_ok_or_error, status, _headers, _body} when status in 500..599 ->
        {:error, :server_down}
    end
  end

  def parse_yaml(content) do
    content
    |> YamlElixir.read_from_string(atoms!: true)
    |> validate_and_build_struct()
  end

  defp validate_and_build_struct(raw_config) when is_map(raw_config) do
    with {:ok, elixir_version} <- fetch_elixir_version(raw_config),
         {:ok, erlang_version} <- fetch_erlang_version(raw_config),
         {:ok, environment_variables} <- fetch_environment_variables(raw_config),
         {:ok, deps} <- fetch_deps(raw_config) do
    %ElixirBench.Runner.Config{
      elixir_version: elixir_version,
      erlang_version: erlang_version,
      environment_variables: environment_variables,
      deps: deps
    }
    end
  end

  defp validate_and_build_struct(_raw_config) do
    {:error, :malformed_config}
  end

  defp fetch_elixir_version(raw_config) do
    supported_elixir_versions = Confex.fetch_env!(:runner, :supported_elixir_versions)

    case Map.fetch(raw_config, "elixir") do
      :error -> {:ok, Confex.fetch_env!(:runner, :default_elixir_version)}
      {:ok, version} when is_binary(version) -> do_fetch_elixir_version(version, supported_elixir_versions)
      {:ok, _version} -> {:error, :malformed_elixir_version}
    end
  end

  defp do_fetch_elixir_version(version, supported_elixir_versions) do
    if version in supported_elixir_versions do
      {:ok, version}
    else
      {:error, {:unsupported_elixir_version, supported_versions: supported_elixir_versions}}
    end
  end

  defp fetch_erlang_version(raw_config) do
    supported_erlang_versions = Confex.fetch_env!(:runner, :supported_erlang_versions)

    case Map.fetch(raw_config, "erlang") do
      :error -> {:ok, Confex.fetch_env!(:runner, :default_erlang_version)}
      {:ok, version} when is_binary(version) -> do_fetch_erlang_version(version, supported_erlang_versions)
      {:ok, _version} -> {:error, :malformed_erlang_version}
    end
  end

  defp do_fetch_erlang_version(version, supported_erlang_versions) do
    if version in supported_erlang_versions do
      {:ok, version}
    else
      {:error, {:unsupported_erlang_version, supported_versions: supported_erlang_versions}}
    end
  end

  defp fetch_environment_variables(%{"environment" => environment_variables}) when is_map(environment_variables) do
    errors = Enum.reject(environment_variables, fn {key, value} -> is_binary(key) and is_binary(value) end)
    if errors == [] do
      {:ok, environment_variables}
    else
      {:error, {:invalid_environment_variables, errors}}
    end
  end
  defp fetch_environment_variables(%{"environment" => environment_variables}) do
    {:error, {:malformed_environment_variables, environment_variables}}
  end
  defp fetch_environment_variables(_raw_config) do
    {:ok, []}
  end

  defp fetch_deps(%{"deps" => %{"docker" => docker_deps}}) when is_list(docker_deps) do
    errors = Enum.reject(docker_deps, fn dep -> Map.has_key?(dep, "image") end)
    if errors == [] do
      {:ok, Enum.map(docker_deps, &Map.fetch!(&1, "image"))}
    else
      {:error, {:invalid_deps, errors}}
    end
  end
  defp fetch_deps(%{"deps" => %{"docker" => docker_deps}}) do
    {:error, {:malformed_deps, docker_deps}}
  end
  defp fetch_deps(_raw_config) do
    {:ok, []}
  end
end
