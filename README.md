<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/ltsv.svg)](https://hex.pm/packages/r_enum)
[![CI](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-r_enum)

# REnum

Extensions and aliases for Enumerable modules inspired by Ruby and Rails.ActiveSupport.
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
# Many useful functions.
# REnum.Enumerable.Ruby.compact()
iex> [1, nil, 2, 3]
iex> |> REnum.compact()
[1, 2, 3]
# REnum.Enumerable.Ruby.tally()
iex> ~w(a c d b c a)
iex> |> REnum.tally()
%{
  "a" => 2,
  "c" => 2,
  "d" => 1,
  "b" => 1
}
# REnum.Enumerable.Ruby.grep()
iex> ["foo", "bar", "car", "moo"]
iex> |> REnum.grep(~r/ar/)
["bar", "car"]
# REnum.Enumerable.Ruby.reverse_each()
iex> [1, 2, 3]
iex> |> REnum.reverse_each(&IO.inspect(&1))
# 3
# 2
# 1
[1, 2, 3]
# Aliases.
# REnum.Enumerable.Ruby.select()
iex> [1, 2, 3]
iex> |> REnum.select(fn x -> rem(x, 2) == 0 end) ==
iex>   Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
true
# Can use Elixir's Enum functions too.
# REnum.Enumerable.Ruby.find()
iex> [1, 2, 3]
iex> |> REnum.find(fn x -> rem(x, 2) == 1 end)
3
# REnum.Enumerable.Ruby.sort()
iex> [1, 2, 3]
iex> REnum.sort()
[1, 2, 3]
```

And more functions. [See also](https://hexdocs.pm/r_enum)

## Docs

See **[hexdocs](https://hexdocs.pm/r_enum)**.

## Roadmap

- [x] 0.1.0
  - REnum.Enumerable.Native
  - REnum.Enumerable.Ruby
  - REnum.Enumerable.Support
  - REnum.List.Native
  - REnum.Map.Native
  - REnum.Range.Native
  - REnum.Stream.Native
  - REnum.Utils
- [x] 0.2.0
  - REnum.Enumerable.ActiveSupport
- [ ] 0.3.0
  - REnum.List.Ruby
- [ ] 0.4.0
  - REnum.List.ActiveSupport
- [ ] 0.5.0
  - REnum.Map.Ruby
  - REnum.Map.ActiveSupport
- [ ] 0.6.0
  - REnum.Range.Ruby
  - REnum.Range.ActiveSupport
- [ ] 0.7.0
  - REnum.Stream.Ruby
  - REnum.Stream.ActiveSupport

## Progress

| REnum        | Elixir Module | Ruby Class       | Elixir | Ruby | ActiveSupport |
| ------------ | ------------- | ---------------- | :----: | :--: | :-----------: |
| REnum        | Enum          | Enumerable       |   ◎    |  ◎   |       ◎       |
| REnum.List   | List          | Array            |   ◎    |  ×   |       ×       |
| REnum.Map    | Map           | Hash             |   ◎    |  ×   |       ×       |
| REnum.Range  | Range         | Range            |   ◎    |  ×   |       ×       |
| REnum.Stream | Stream        | Enumerator::Lazy |   ◎    |  ×   |       ×       |
