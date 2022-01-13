<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/ltsv.svg)](https://hex.pm/packages/r_enum)
[![CI](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-r_enum)

# REnum

Extensions for and aliases Enumerable modules inspired by Ruby and Rails.ActiveSupport.
It also provides full support for native functions through metaprogramming.

## Installation

```elixir
def deps do
  [
    {:r_enum, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
 # TODO:
```

## Docs

See **[hexdocs](https://hexdocs.pm/r_enum)**.

## Implementation Progress

| REnum        | Elixir Module | Ruby Class       | Elixir | Ruby | ActiveSupport |
| ------------ | ------------- | ---------------- | :----: | :--: | :-----------: |
| REnum        | Enum          | Enumerable       |   ◎    |  ◎   |       ×       |
| REnum.List   | List          | Hash             |   ◎    |  ×   |       ×       |
| REnum.Map    | Map           | List             |   ◎    |  ×   |       ×       |
| REnum.Range  | Range         | Range            |   ◎    |  ×   |       ×       |
| REnum.Stream | Stream        | Enumerator::Lazy |   ◎    |  ×   |       ×       |
