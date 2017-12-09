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
      extra_applications: [:logger],
      mod: {ElixirBench.Runner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 1.3"},
      {:confex, "~> 3.3"},
      {:hackney, "~> 1.10"},
      {:antidote, github: "michalmuskala/antidote", branch: "master"},
    ]
  end
end
