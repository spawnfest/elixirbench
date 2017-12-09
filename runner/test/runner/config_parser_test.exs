defmodule ElixirBench.Runner.ConfigParserTest do
  use ExUnit.Case, async: true
  import ElixirBench.Runner.ConfigParser

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

  describe "parse_yaml/1" do
    test "builds Config struct from yaml" do
      config = """
      elixir: 1.5.2
      erlang: 20.1.2
      environment:
        PG_URL: postgres:postgres@localhost
        MYSQL_URL: root@localhost
      deps:
        docker:
          - image: postgres:alpine-latest
          - image: mysql:latest
      """

      assert parse_yaml(config) == %ElixirBench.Runner.Config{
        deps: ["postgres:alpine-latest", "mysql:latest"],
        elixir_version: "1.5.2",
        environment_variables: %{
          "MYSQL_URL" => "root@localhost",
          "PG_URL" => "postgres:postgres@localhost"
        },
        erlang_version: "20.1.2"
      }
    end

    test "assigns default elixir and erlang versions" do
      config = """
      deps:
        docker:
          - image: postgres:alpine-latest
          - image: mysql:latest
      """

      assert %{elixir_version: "1.5.2", erlang_version: "20.1.2"} = parse_yaml(config)
    end

    test "validates elixir version" do
      config = """
      elixir: 1.5.2
      erlang: 20.1.2
      """

      assert %{elixir_version: "1.5.2"} = parse_yaml(config)

      config = """
      elixir: 21.5.2
      erlang: 20.1.2
      """

      assert {:error, {:unsupported_elixir_version, [supported_versions: _]}} = parse_yaml(config)
    end

    test "validates erlang version" do
      config = """
      elixir: 1.5.2
      erlang: 20.1.2
      """

      assert %{erlang_version: "20.1.2"} = parse_yaml(config)

      config = """
      elixir: 1.5.2
      erlang: 17.1.2
      """

      assert {:error, {:unsupported_erlang_version, [supported_versions: _]}} = parse_yaml(config)
    end

    test "returns error for malformed files" do
      config = """
      Malformed config
      """
      assert parse_yaml(config) == {:error, :malformed_config}
    end
  end
end
