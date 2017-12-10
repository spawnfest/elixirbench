use Mix.Config

config :runner, :default_elixir_version, {:system, "DEFAULT_ELIXIR_VERSION", "1.5.2"}
config :runner, :supported_elixir_versions, {:system, :list, "SUPPORTED_ELIXIR_VERSIONS", ["1.5.2"]}

config :runner, :default_erlang_version, {:system, "DEFAULT_ERLANG_VERSION", "20.1.2"}
config :runner, :supported_erlang_versions, {:system, :list, "SUPPORTED_ERLANG_VERSIONS", ["20.1.2"]}

config :runner, :benchmars_output_path, {:system, "BENCHMARKS_OUTPUT_PATH", "/tmp/benchmarks"}
config :runner, :container_benchmars_output_path, "/var/bench"

config :runner, :job_timeout, {:system, :integer, "JOB_TIMEOUT", 900_000}

config :runner, :api_user, {:system, "RUNNER_API_USER"}
config :runner, :api_key, {:system, "RUNNER_API_KEY"}

config :logger, level: :info
