defmodule Saxophone.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi2"
  @base_build System.get_env("NERVES_BUILD") || "_build"

  def project do
    [app: :saxophone,
     version: "0.1.1",
     elixir: "~> 1.2.4",
     archives: [nerves_bootstrap: "~> 0.1"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     target: @target,
     deps_path: "deps/#{@target}",
     build_path: "#{@base_build}/#{@target}",
     config_path: "config/#{@target}/config.exs",
     aliases: aliases(Mix.env),
     deps: deps ++ system(@target, Mix.env)]
  end

  def application do
    [applications: applications, mod: {Saxophone, {}}]
  end

  defp deps do
    [{:nerves, github: "nerves-project/nerves"},
     {:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.1.3"},
     {:elixir_ale, "~> 0.5.0" ,only: [:prod]},
     {:nerves_networking, github: "nerves-project/nerves_networking", only: :prod},
     {:websocket_client, github: "jeremyong/websocket_client"},
     {:slacker,  "~> 0.0.2"},
     {:nerves_interim_wifi, path: "../nerve-libs/nerves_interim_wifi", only: :prod},
     {:credo, "~> 0.3", only: [:dev, :test]}]
  end

  defp applications do
    general_apps = [:logger, :cowboy, :plug, :slacker, :websocket_client, :ssl, :crypto, :runtime_tools, :porcelain]
    case Mix.env do
      :prod -> [:nerves, :nerves_networking, :elixir_ale, :nerves_interim_wifi | general_apps]
      _ -> general_apps
    end |> IO.inspect
  end

  def system("rpi2", :prod) do
    [{:nerves_system_rpi2, github: "nerves-project/nerves_system_rpi2"}]
    # [{:nerves_system_rpi2, path: "../nerve-libs/nerves_system_rpi2"}]
  end
  def system(_, _), do: []


  def aliases(:prod) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
  def aliases(_), do: []
end
