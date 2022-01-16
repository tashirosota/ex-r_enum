<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/ltsv.svg)](https://hex.pm/packages/r_enum)
[![CI](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-r_enum)

# REnum

**Many useful functions implemented.**
REnum is Enum extended with convenient functions inspired by Ruby and Rails ActiveSupport.
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

You can use all of `Enum.Enumerable.*` functions through REnum Module.

```elixir
# Examples.
# REnum.Ruby.compact()
iex> [1, nil, 2, 3]
iex> |> REnum.compact()
[1, 2, 3]
# REnum.Ruby.tally()
iex> ~w(a c d b c a)
iex> |> REnum.tally()
%{
  "a" => 2,
  "c" => 2,
  "d" => 1,
  "b" => 1
}
# REnum.Ruby.grep()
iex> ["foo", "bar", "car", "moo"]
iex> |> REnum.grep(~r/ar/)
["bar", "car"]
# REnum.Ruby.reverse_each()
iex> [1, 2, 3]
iex> |> REnum.reverse_each(&IO.inspect(&1))
# 3
# 2
# 1
[1, 2, 3]
# REnum.ActiveSupport.pluck()
iex> payments = [
...>   %Payment{dollars: 5, cents: 99},
...>   %Payment{dollars: 10, cents: 0},
...>   %Payment{dollars: 0, cents: 5}
...> ]
iex> |> REnum.pluck(:dollars)
[5, 10, 0]
# REnum.ActiveSupport.maximum()
iex> REnum.maximum(payments, :dollars)
10
# REnum.ActiveSupport.without()
iex> 1..5
iex> |> REnum.without([1, 5])
[2, 3, 4]

# Aliases.
# REnum.Ruby.select()
iex> [1, 2, 3]
iex> |> REnum.select(fn x -> rem(x, 2) == 0 end) ==
iex>   Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
true
# Can use Elixir's Enum functions too.
# REnum.Ruby.find()
iex> [1, 2, 3]
iex> |> REnum.find(fn x -> rem(x, 2) == 1 end)
3
# REnum.Ruby.sort()
iex> [1, 2, 3]
iex> REnum.sort()
[1, 2, 3]
```

And more functions. [See also](https://hexdocs.pm/r_enum)

## Docs

See **[hexdocs](https://hexdocs.pm/r_enum)**.

## Roadmap

- [x] 0.1.0
  - REnum.Native
  - REnum.Ruby
  - REnum.Support
  - RList.Native
  - RMap.Native
  - RRange.Native
  - RStream.Native
  - RUtils
- [x] 0.2.0
  - REnum.ActiveSupport
- [ ] 0.4.0
  - RList.Ruby
- [ ] 0.5.0
  - RList.ActiveSupport
- [ ] 0.6.0
  - RMap.Ruby
  - RMap.ActiveSupport
- [ ] 0.7.0
  - RRange.Ruby
  - RRange.ActiveSupport
- [ ] 0.8.0
  - RStream.Ruby
  - RStream.ActiveSupport

## Progress

| REnum   | Elixir Module | Ruby Class       | Elixir | Ruby | ActiveSupport |
| ------- | ------------- | ---------------- | :----: | :--: | :-----------: |
| REnum   | Enum          | Enumerable       |   ◎    |  ◎   |       ◎       |
| RList   | List          | Array            |   ◎    |  ×   |       ×       |
| RMap    | Map           | Hash             |   ◎    |  ×   |       ×       |
| RRange  | Range         | Range            |   ◎    |  ×   |       ×       |
| RStream | Stream        | Enumerator::Lazy |   ◎    |  ×   |       ×       |
