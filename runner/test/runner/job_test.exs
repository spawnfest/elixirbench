defmodule ElixirBench.Runner.JobTest do
  use ExUnit.Case
  import ElixirBench.Runner.Job
  alias ElixirBench.Runner.Job

  @moduletag timeout: :infinity, docker_integration: true, requires_internet_connection: true

  test "run_job/1" do
    raw_config = """
    elixir: 1.5.2
    erlang: 20.1.2
    environment:
      PG_URL: postgres:postgres@localhost
      MYSQL_URL: root@localhost
    deps:
      docker:
        - container_name: postgres
          image: postgres:9.6.6-alpine
        - container_name: mysql
          image: mysql:5.7.20
          environment:
            MYSQL_ALLOW_EMPTY_PASSWORD: "true"
    """

    {:ok, config} = ElixirBench.Runner.Config.Parser.parse_yaml(raw_config)

    job = %Job{
      id: "test_job",
      repo_slug: "elixir-ecto/ecto",
      branch: "mm/benches",
      commit: "2a5a8efbc3afee3c6893f4cba33679e98142df3f",
      config: config
    }

    job = run_job(job)

    assert job.status == 0
    assert job.log =~ "Cloning the repo.."
    assert length(job.measurements) > 1

    # Make sure context is present
    assert is_binary(Keyword.fetch!(job.context.mix_deps, :benchee))
    assert is_binary(job.context.worker_available_memory)
    assert is_binary(job.context.worker_cpu_speed)
    assert job.context.worker_num_cores in 1..64
    assert job.context.worker_os in [:linux, :windows, :macOS]
  end
end
