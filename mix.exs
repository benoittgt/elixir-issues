defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [app: :issues,
     escript: escript_config,
     version: "0.0.1",
     name: "issues",
     source_url: "https://github.com/benoittgt/elixir-issues",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
     ]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:ex_doc,    "~> 0.11"},
      {:earmark,   ">= 0.0.0"},
      {:poison,    "~> 1.5"},
      {:exvcr,     "~> 0.7", only: :test},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:dogma, "~> 0.1", only: :dev},
    ]
  end

  defp escript_config do
    [ main_module: Issues.CLI ]
  end
end
