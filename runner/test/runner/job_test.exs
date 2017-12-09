defmodule ElixirBench.Runner.JobTest do
  use ExUnit.Case
  import ElixirBench.Runner.Job

  @tag timeout: :infinity
  describe "start_job/4" do
    test "starts runner with dependencies" do
      IO.inspect start_job("priv/bench/results", "elixir-ecto/ecto", "mm/benches", "c5647e87f445b05ba67422a46233599569e09176")
    end
  end

end
