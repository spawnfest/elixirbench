use Mix.Config

config :runner, :default_elixir_version, "1.5.2"
config :runner, :supported_elixir_versions, ["1.5.2"]

config :runner, :default_erlang_version, "20.1.2"
config :runner, :supported_erlang_versions, ["20.1.2"]

config :runner, :benchmarking_results_path, "/tmp/benchmarks"
config :runner, :container_benchmarking_results_path, "/var/bench"
