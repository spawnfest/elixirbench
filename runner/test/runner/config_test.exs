defmodule ElixirBench.Runner.ConfigTest do
  use ExUnit.Case, async: true
  import ElixirBench.Runner.Config

  @repo_slug_fixture "elixir-ecto/ecto"
  @branch_fixture "mm/benches"
  @commit_fixture "207b2a0fb5407b7162a454a12bacf8f1a4c962c0"

  @tag requires_internet_connection: true
  describe "fetch_config_by_repo_slug/1" do
    test "loads configuration from repo" do
      assert {:ok, %ElixirBench.Runner.Config{}} = fetch_config_by_repo_slug(@repo_slug_fixture, @branch_fixture)
      assert {:ok, %ElixirBench.Runner.Config{}} = fetch_config_by_repo_slug(@repo_slug_fixture, @commit_fixture)
    end

    test "returns error when file does not exist" do
      assert fetch_config_by_repo_slug("elixir-ecto/ecto", "not_a_branch") == {:error, :config_not_found}
      assert fetch_config_by_repo_slug("not-elixir-ecto/ecto", "mm/benches") == {:error, :config_not_found}
      assert fetch_config_by_repo_slug("not-elixir-ecto/ecto") == {:error, :config_not_found}
    end
  end
end
