defmodule ElixirBench.Runner.ConfigTest do
  use ExUnit.Case, async: true
  import ElixirBench.Runner.Config

  @tag requires_internet_connection: true
  describe "fetch_config_by_repo_slug/1" do
    test "loads configuration from repo" do
      assert %ElixirBench.Runner.Config{} = fetch_config_by_repo_slug("elixir-ecto/ecto", "mm/benches")
    end

    test "returns error when file does not exist" do
      assert fetch_config_by_repo_slug("not-elixir-ecto/ecto", "mm/benches") == {:error, :config_not_found}
      assert fetch_config_by_repo_slug("not-elixir-ecto/ecto") == {:error, :config_not_found}
    end
  end
end
