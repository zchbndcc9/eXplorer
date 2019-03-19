defmodule Explore.MixProject do
  use Mix.Project

  def project do
    [
      app: :explore,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :floki, "~> 0.20.0" },
      { :httpoison, "~> 1.4" },
      { :stemmer, "~> 1.0" }
    ]
  end
end
