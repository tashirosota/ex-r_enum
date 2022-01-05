defmodule Rubenum.MixProject do
  use Mix.Project
  @versoin "0.1.0"
  @source_url "https://github.com/tashirosota/ex-rubenum"
  @description "Extensions for Enumerable modules compatibled with Ruby and Rails.ActiveSupport."
  def project do
    [
      app: :rubenum,
      version: @versoin,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: @description,
      name: "Rubenum",
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Sota Tashiro"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
