defmodule ElixirBench.Runner.Config do
  @moduledoc """
  This module is responsible for fetching YAML configuration from project repo
  and struct in which we would store job configuration.
  """
  defstruct elixir_version: nil, erlang_version: nil, environment_variables: [], deps: []

  @github_base_url "https://raw.githubusercontent.com/"

  @doc """
  Fetch config from a GitHub repo by it's slug.

  Right now It's only possible to fetch config from a public repo.
  """
  def fetch_config_by_repo_slug(repo_slug, branch_or_commit \\ "") do
    repo_slug = String.trim(repo_slug, "/")
    branch_or_commit = String.trim(branch_or_commit, "/")
    url =
      if branch_or_commit == "" do
        [@github_base_url, repo_slug, "/bench/config.yml"]
      else
        [@github_base_url, repo_slug, "/", branch_or_commit, "/bench/config.yml"]
      end

    with {:ok, content} <- fetch_file_contents(url) do
      ElixirBench.Runner.Config.Parser.parse_yaml(content)
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
end
