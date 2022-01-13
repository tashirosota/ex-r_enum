defmodule REnum.MixProject do
  use Mix.Project
  @versoin "0.1.0"
  @source_url "https://github.com/tashirosota/ex-r_enum"
  @description "Extensions for Enumerable modules inspired by Ruby and Rails.ActiveSupport."
  def project do
    [
      app: :r_enum,
      version: @versoin,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: @description,
      name: "REnum",
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      elixirc_paths: elixirc_paths(Mix.env())
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
