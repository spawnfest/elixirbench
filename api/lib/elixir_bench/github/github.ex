defmodule ElixirBench.Github do
  require Logger

  alias ElixirBench.Github.Client

  def fetch_config(repo_owner, repo_name, branch_or_commit) do
    path = [repo_owner, "/", repo_name, "/", branch_or_commit, "/bench/config.yml"]
    slug = "#{repo_owner}/#{repo_name}##{branch_or_commit}"
    Logger.info("Requesting bench config for: #{slug}")
    case Client.get_yaml(raw_client(), path) do
      {:ok, config} ->
        {:ok, config}
      {:error, {404, _}} ->
        {:error, :failed_config_fetch}
      {:error, reason} ->
        Logger.error("Failed to fetch config for #{slug}: #{inspect reason}")
        {:error, :failed_config_fetch}
    end
  end

  def raw_client() do
    %Client{base_url: "https://raw.githubusercontent.com"}
  end
end
