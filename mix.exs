defmodule REnum.MixProject do
  use Mix.Project
  @versoin "0.1.0"
  @source_url "https://github.com/tashirosota/ex-r_enum"
  @description "Extensions and aliases for Enumerable modules inspired by Ruby and Rails.ActiveSupport."
  def project do
    [
      app: :r_enum,
      version: @versoin,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: @description,
      name: "REnum",
      package: package(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
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

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      groups_for_modules: groups_for_modules()
    ]
  end

  defp groups_for_modules do
    [
      Enum: [
        REnum,
        REnum.Enumerable.Native,
        REnum.Enumerable.Ruby,
        REnum.Enumerable.ActiveSupport,
        REnum.Enumerable.Support
      ],
      List: [
        REnum.List,
        REnum.List.Native,
        REnum.List.Ruby,
        REnum.List.ActiveSupport
      ],
      Map: [
        REnum.Map,
        REnum.Map.Native,
        REnum.Map.Ruby,
        REnum.Map.ActiveSupport
      ],
      Range: [
        REnum.Range,
        REnum.Range.Native,
        REnum.Range.Ruby,
        REnum.Range.ActiveSupport
      ],
      Stream: [
        REnum.Stream,
        REnum.Stream.Native,
        REnum.Stream.Ruby,
        REnum.Stream.ActiveSupport
      ],
      Utils: [
        REnum.Utils
      ]
    ]
  end
end
