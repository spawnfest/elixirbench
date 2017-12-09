defmodule ElixirBench.RunnerTest do
  use ExUnit.Case
  doctest ElixirBench.Runner

  test "greets the world" do
    assert ElixirBench.Runner.hello() == :world
  end
end
