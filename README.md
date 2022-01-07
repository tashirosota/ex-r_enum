<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/ltsv.svg)](https://hex.pm/packages/r_enum)
[![CI](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-r_enum)

# REnum

**WIP**

Extensions for Enumerable modules compatibled with Ruby and Rails.ActiveSupport.
And it perfect support for native functions too by metaprogramming.

## Installation

```elixir
def deps do
  [
    {:r_enum, "~> 0.1.0"}
  ]
end
```

**[docs](https://hexdocs.pm/r_enum)**

```elixir
 # TODO:
```

## Implementation

### Relation

| REnum        | Elixir | Ruby                           |
| ------------ | ------ | ------------------------------ |
| REnum        | Enum   | Enumerable                     |
| REnum.List   | List   | Array                          |
| REnum.Map    | Map    | Hash                           |
| REnum.Range  | Range  | Range                          |
| REnum.Stream | Stream | Enumerator（Enumerator::Lazy） |

### Progress

| REnum        | Native Elixir | Ruby | ActiveSupport |
| ------------ | :-----------: | :--: | :-----------: |
| REnum        |       ◎       |  ×   |       ×       |
| REnum.List   |       ◎       |  ×   |       ×       |
| REnum.Map    |       ◎       |  ×   |       ×       |
| REnum.Range  |       ◎       |  ×   |       ×       |
| REnum.Stream |       ◎       |  ×   |       ×       |
