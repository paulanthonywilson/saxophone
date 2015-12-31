defmodule Saxophone.Mixfile do
  use Mix.Project

  def project do
    [app: :saxophone,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :ethernet],
     mod: {Saxophone, {}}]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.0"},
     { :ethernet, git: "https://github.com/cellulose/ethernet.git" },
    {:exrm, "~> 1.0.0-rc7"}]
  end
end
