defmodule Markhoff.Mixfile do
  use Mix.Project

  def project do
    [app: :markhoff,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :nostrum, :ecto, :postgrex, :timex],
      mod: {Markhoff, []}
    ]
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
      {:nostrum, git: "https://github.com/Kraigie/nostrum.git"},
      # {:nostrum, git: "../nostrum"},
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.11"},
      {:timex, "~> 3.0"}
    ]
  end
end
