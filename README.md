<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/ltsv.svg)](https://hex.pm/packages/rubenum)
[![CI](https://github.com/tashirosota/ex-rubenum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-rubenum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-rubenum)

# Rubenum

**WIP**

Extensions for Enumerable modules compatibled with Ruby and Rails.ActiveSupport.
And it perfect support for native functions too by metaprogramming.

## Installation

```elixir
def deps do
  [
    {:rubenum, "~> 0.1.0"}
  ]
end
```

**[docs](https://hexdocs.pm/rubenum)**

```elixir
 # TODO:
```

## Implementation

### Relation

| Rubenum        | Elixir | Ruby                           |
| -------------- | ------ | ------------------------------ |
| Rubenum        | Enum   | Enumerable                     |
| Rubenum.List   | List   | Array                          |
| Rubenum.Map    | Map    | Hash                           |
| Rubenum.Range  | Range  | Range                          |
| Rubenum.Stream | Stream | Enumerator（Enumerator::Lazy） |

### Progress

| Rubenum        | Native Elixir | Ruby | ActiveSupport |
| -------------- | :-----------: | :--: | :-----------: |
| Rubenum        |       ◎       |  ×   |       ×       |
| Rubenum.List   |       ◎       |  ×   |       ×       |
| Rubenum.Map    |       ◎       |  ×   |       ×       |
| Rubenum.Range  |       ◎       |  ×   |       ×       |
| Rubenum.Stream |       ◎       |  ×   |       ×       |
