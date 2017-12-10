defmodule ElixirBench.Runner.Config do
  defstruct elixir_version: nil, erlang_version: nil, environment_variables: [], deps: []

  def from_string_map(map) do
    %{
      "elixir_version" => elixir,
      "erlang_version" => erlang,
      "environment_variables" => env,
      "deps" => %{"docker" => docker}
    } = map
    %__MODULE__{
      elixir_version: elixir,
      erlang_version: erlang,
      environment_variables: env,
      deps: docker
    }
  end
end
