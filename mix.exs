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
    [applications: applications,
     mod: {Saxophone, {}}]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.0"},
     {:elixir_ale, "~> 0.4.1" ,only: [:prod]},
     {:ethernet, git: "https://github.com/cellulose/ethernet.git", only: :prod},
     {:websocket_client, github: "jeremyong/websocket_client"},
     {:slacker,  "~> 0.0.1"},
     {:exrm, "~> 1.0.0-rc7"}]
  end

  defp applications do
    general_apps = [:logger, :cowboy, :plug, :poison, :httpoison]
    case Mix.env do
      :prod -> [:ethernet, :elixir_ale | general_apps]
      _ -> general_apps
    end |> IO.inspect
  end
end
