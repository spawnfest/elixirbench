defmodule ElixirBench.Runner.Config.ParserTest do
  use ExUnit.Case, async: true
  import ElixirBench.Runner.Config.Parser

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

      assert parse_yaml(config) == {:ok, %ElixirBench.Runner.Config{
        deps: [%{"image" => "postgres:alpine-latest"}, %{"image" => "mysql:latest"}],
        elixir_version: "1.5.2",
        environment_variables: %{
          "MYSQL_URL" => "root@localhost",
          "PG_URL" => "postgres:postgres@localhost"
        },
        erlang_version: "20.1.2"
      }}
    end

    test "assigns default elixir and erlang versions" do
      config = """
      deps:
        docker:
          - image: postgres:alpine-latest
          - image: mysql:latest
      """

      assert {:ok, %{elixir_version: "1.5.2", erlang_version: "20.1.2"}} = parse_yaml(config)
    end

    test "validates elixir version" do
      config = """
      elixir: 1.5.2
      erlang: 20.1.2
      """

      assert {:ok, %{elixir_version: "1.5.2"}} = parse_yaml(config)

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

      assert {:ok, %{erlang_version: "20.1.2"}} = parse_yaml(config)

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
