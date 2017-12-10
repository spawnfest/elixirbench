defmodule ElixirBench.Runner.MixProject do
  use Mix.Project

  def project do
    [
      app: :runner,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ElixirBench.Runner.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 1.3"},
      {:confex, "~> 3.3"},
      {:hackney, "~> 1.10"},
      {:antidote, github: "michalmuskala/antidote", branch: "master"},
      {:benchee, "~> 0.11.0"},
      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
