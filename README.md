<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/r_enum.svg)](https://hex.pm/packages/r_enum)
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
    {:r_enum, "~> 0.1"}
  ]
end
```

## Usage

You can use all of `Enum.Enumerable.*` functions through REnum Module.

```elixir
# Examples.
# REnum.Ruby.compact/1
iex> [1, nil, 2, 3]
iex> |> REnum.compact()
[1, 2, 3]

# REnum.Ruby.grep/2
iex> ["foo", "bar", "car", "moo"]
iex> |> REnum.grep(~r/ar/)
["bar", "car"]

# REnum.Ruby.each_slice/2
iex> [1, 2, 3, 4, 5, 6, 7]
iex> |> REnum.each_slice(3)
iex> |> REnum.to_list()
[[1, 2, 3], [4, 5, 6], [7]]

# REnum.ActiveSupport.pluck/2
iex> payments = [
...>   %Payment{dollars: 5, cents: 99},
...>   %Payment{dollars: 10, cents: 0},
...>   %Payment{dollars: 0, cents: 5}
...> ]
iex> |> REnum.pluck(:dollars)
[5, 10, 0]

# REnum.ActiveSupport.maximum/2
iex> REnum.maximum(payments, :dollars)
10

# REnum.ActiveSupport.without/2
iex> 1..5
iex> |> REnum.without([1, 5])
[2, 3, 4]

# RList.Ruby.combination/2
iex> [1, 2, 3, 4]
iex> RList.combination(3)
iex> |> Enum.to_list()
[[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
# See also RList.Ruby.repeated_combination, RList.Ruby.permutation, RList.Ruby.repeated_permutation

# RList.Ruby.push/2
iex> [:foo, 'bar', 2]
iex> |> RList.push([:baz, :bat])
[:foo, 'bar', 2, :baz, :bat]
# See also RList.Ruby.pop, RList.Ruby.shift, RList.Ruby.unshift

# RList.ActiveSupport.second/1
iex> [:foo, 'bar', 2]
iex> |> RList.second()
'bar'
# See also RList.ActiveSupport.second, RList.ActiveSupport.third, RList.ActiveSupport.fourth, RList.ActiveSupport.fifth, RList.ActiveSupport.forty_two

# RList.ActiveSupport.from/2
iex> ~w[a b c d]
iex> |> RList.from(2)
["c", "d"]
# See also RList.ActiveSupport.to

# Aliases.
# REnum.Ruby.select2
iex> [1, 2, 3]
iex> |> REnum.select(fn x -> rem(x, 2) == 0 end) ==
iex>   Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
true

# Can use Elixir's Enum functions too.
# REnum.Ruby.find/2
iex> [1, 2, 3]
iex> |> REnum.find(fn x -> rem(x, 2) == 1 end)
3

# REnum.Ruby.sort/1
iex> [1, 2, 3]
iex> REnum.sort()
[1, 2, 3]
```

For the full list of available functions, see [API Reference](https://hexdocs.pm/r_enum/api-reference.html).

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
- [x] 0.4.0
  - RList.Ruby
- [x] 0.5.0
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
| REnum   | Enum          | Enumerable       |   ✅   |  ✅  |      ✅       |
| RList   | List          | Array            |   ✅   |  ✅  |      ✅       |
| RMap    | Map           | Hash             |   ✅   | TODO |     TODO      |
| RRange  | Range         | Range            |   ✅   | TODO |     TODO      |
| RStream | Stream        | Enumerator::Lazy |   ✅   | TODO |     TODO      |
