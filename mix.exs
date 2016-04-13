defmodule Saxophone.Mixfile do
  use Mix.Project

  def project do
    [app: :saxophone,
     version: "0.0.2",
     elixir: "~> 1.2.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: applications,
     mod: {Saxophone, {}}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.1.3"},
     {:elixir_ale, "~> 0.5.0" ,only: [:prod]},
     {:nerves_networking, github: "nerves-project/nerves_networking", only: :prod},
     {:websocket_client, github: "jeremyong/websocket_client"},
     {:slacker,  "~> 0.0.2"},
     {:exrm, "~> 1.0.3"}]
  end

  defp applications do
    general_apps = [:logger, :cowboy, :plug, :slacker, :websocket_client, :ssl]
    case Mix.env do
      :prod -> [:nerves_networking, :elixir_ale | general_apps]
      _ -> general_apps
    end |> IO.inspect
  end
end
