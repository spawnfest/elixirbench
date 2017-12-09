defmodule ElixirBench.Runner.JobTest do
  use ExUnit.Case
  import ElixirBench.Runner.Job

  @tag timeout: :infinity
  describe "start_job/4" do
    test "starts runner with dependencies" do
      IO.inspect start_job("priv/bench/results", "elixir-ecto/ecto", "mm/benches", "4bcaf9131aefb7f1e956ff196307e82f8f7a1870")
    end
  end

end
