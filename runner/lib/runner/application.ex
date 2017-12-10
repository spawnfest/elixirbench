defmodule ElixirBench.Runner.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: ElixirBench.Runner.JobsSupervisor},
      {ElixirBench.Runner, name: ElixirBench.Runner}
    ]

    opts = [strategy: :one_for_one, name: ElixirBench.Runner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
