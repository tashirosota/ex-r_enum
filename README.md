[![hex.pm version](https://img.shields.io/hexpm/v/r_enum.svg)](https://hex.pm/packages/r_enum)
[![CI](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/ex-r_enum/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/ex-r_enum)

# REnum

REnum is Enum extended with convenient functions inspired by Ruby and Rails ActiveSupport.
It also provides full support for native functions through metaprogramming.
In addition to REnum, modules such as RList, RMap, RRange can also be used.

- [REnum](#renum)
  - [Installation](#installation)
  - [About REnum](#about-renum)
    - [compact/1](#compact-1)
    - [each_slice/2](#each_slice-2)
    - [grep/2](#grep-2)
    - [reverse_each/2](#reverse_each-2)
    - [pluck/2](#pluck-2)
    - [exclude?/2](#exclude-2)
    - [without/2](#without-2)
    - [many?/2](#many-2)
    - [list_and_not_keyword?/1](#list_and_not_keyword-1)
    - [map_and_not_range?/1](#map_and_not_range-1)
  - [About RList](#about-rlist)
    - [push/2](#push-2)
    - [combination/2](#combination-2)
    - [fill/3](#fill-3)
    - [dig/3](#dig-3)
    - [intersection/2](#intersection-2)
    - [sample/2](#sample-2)
    - [values_at/1](#values_at-1)
    - [second/1](#second-1)
    - [from/2](#from-2)
    - [to_sentence/2](#to_sentence-2)
    - [new/2](#new-2)
  - [About RMap](#about-rmap)
    - [dig/2](#dig-2)
    - [each_key/2](#each_key-2)
    - [except/2](#except-2)
    - [invert/1](#invert-1)
    - [values_at/2](#values_at-2)
    - [deep_atomize_keys/1](#deep_atomize_keys-1)
    - [deep_transform_keys/2](#deep_transform_keys-2)
  - [About RRange](#about-rrange)
    - [begin/1](#begin-1)
    - [step/2](#step-2)
    - [overlaps?/2](#overlaps-2)
  - [About RUtils](#about-rutils)
    - [blank?/1](#blank-1)
    - [present?/1](#present-1)
    - [define_all_functions!/2](#define_all_functions-2)
  - [Progress](#progress)

## Installation

```elixir
def deps do
  [
    {:r_enum, "~> 0.6"}
  ]
end
```

For the full list of available functions, see [API Reference](https://hexdocs.pm/r_enum/api-reference.html).

## About [REnum](https://hexdocs.pm/r_enum/REnum.html)

**All the functions are available defined in**

- [Enum](https://hexdocs.pm/r_enum/REnum.Native.html)
- [REnum.Ruby](https://hexdocs.pm/r_enum/REnum.Ruby.html)
- [REnum.ActiveSupport](https://hexdocs.pm/r_enum/REnum.ActiveSupport.html)
- [REnum.Support](https://hexdocs.pm/r_enum/REnum.Support.html)

### compact/1

Returns an list of all non-nil elements.

```elixir
iex> REnum.compact([1, nil, 2, 3])
[1, 2, 3]
# See also REnum.ActiveSupport.compact_blank
```

### each_slice/2

Returns Stream given enumerable sliced by each amount.

```elixir
iex> ["a", "b", "c", "d", "e"]
iex> |> REnum.each_slice(2)
iex> |> Enum.to_list()
[["a", "b"], ["c", "d"], ["e"]]
```

### grep/2

Returns elements selected by a given pattern or function.

```elixir
iex> ["foo", "bar", "car", "moo"]
iex> |> REnum.grep(~r/ar/)
["bar", "car"]

iex> 1..10
iex> |> REnum.grep(3..8)
[3, 4, 5, 6, 7, 8]
```

### reverse_each/2

Calls the function with each element, but in reverse order; returns given enumerable.

```elixir
iex> REnum.reverse_each([1, 2, 3], &IO.inspect(&1))
# 3
# 2
# 1
[1, 2, 3]
```

### pluck/2

Extract the given key from each element in the enumerable.

```elixir
iex> payments = [
...>   %Payment{dollars: 5, cents: 99},
...>   %Payment{dollars: 10, cents: 0},
...>   %Payment{dollars: 0, cents: 5}
...> ]
iex> REnum.pluck(payments, [:dollars, :cents])
[[5, 99], [10, 0], [0, 5]]
iex> REnum.pluck(payments, :dollars)
[5, 10, 0]
iex> REnum.pluck([], :dollars)
[]
```

### exclude?/2

The negative of the `Enum.member?`.Returns true+if the collection does not include the object.

```elixir
iex> REnum.exclude?([2], 1)
true

iex> REnum.exclude?([2], 2)
false
# See also REnum.ActiveSupport.include?
```

### without/2

Returns enumerable excluded the specified elements.

```elixir
iex> REnum.without(1..5, [1, 5])
[2, 3, 4]

iex> REnum.without(%{foo: 1, bar: 2, baz: 3}, [:bar])
%{foo: 1, baz: 3}
# See also REnum.ActiveSupport.including
```

### many?/2

Returns true if the enumerable has more than 1 element.

```elixir
iex>  REnum.many?([])
false

iex> REnum.many?([1])
false

iex> REnum.many?([1, 2])
true

iex> REnum.many?(%{})
false

iex> REnum.many?(%{a: 1})
false

iex> REnum.many?(%{a: 1, b: 2})
true
```

### list_and_not_keyword?/1

Returns true if argument is list and not keyword list.

```elixir
iex> REnum.list_and_not_keyword?([1, 2, 3])
true

iex> REnum.list_and_not_keyword?([a: 1, b: 2])
false
```

### map_and_not_range?/1

Returns true if argument is map and not range.

```elixir
iex> REnum.map_and_not_range?(%{})
true

iex> REnum.map_and_not_range?(1..3)
false
```

## About [RList](https://hexdocs.pm/r_enum/RList.html)

RList is List extended with convenient functions inspired by Ruby and Rails ActiveSupport.
**All the functions are available defined in**

- [List](https://hexdocs.pm/r_enum/RList.Native.html)
- [REnum](https://hexdocs.pm/r_enum/REnum.html)
- [RList.Ruby](https://hexdocs.pm/r_enum/RList.Ruby.html)
- [RList.ActiveSupport](https://hexdocs.pm/r_enum/RList.ActiveSupport.html)
- [RList.Support](https://hexdocs.pm/r_enum/RList.Support.html)

### push/2

Appends trailing elements.

```elixir
iex> [:foo, 'bar', 2]
iex> |> RList.push([:baz, :bat])
[:foo, 'bar', 2, :baz, :bat]

iex> [:foo, 'bar', 2]
iex> |> RList.push(:baz)
[:foo, 'bar', 2, :baz]
# See also REnum.Ruby.shift, REnum.Ruby.pop, REnum.Ruby.unshift
```

### combination/2

Returns Stream that is each repeated combinations of elements of given list. The order of combinations is indeterminate.

```elixir
iex> RList.combination([1, 2, 3, 4], 1)
iex> |> Enum.to_list()
[[1],[2],[3],[4]]

iex> RList.combination([1, 2, 3, 4], 3)
iex> |> Enum.to_list()
[[1,2,3],[1,2,4],[1,3,4],[2,3,4]]

iex> RList.combination([1, 2, 3, 4], 0)
iex> |> Enum.to_list()
[[]]

iex> RList.combination([1, 2, 3, 4], 5)
iex> |> Enum.to_list()
[]
# See also RList.Ruby.repeated_combination, RList.Ruby.permutation, RList.Ruby.repeated_permutation
```

### fill/3

Fills the list with the provided value. The filler can be either a function or a fixed value.

```elixir
iex> RList.fill(~w[a b c d], "x")
["x", "x", "x", "x"]

iex> RList.fill(~w[a b c d], "x", 0..1)
["x", "x", "c", "d"]

iex> RList.fill(~w[a b c d], fn _, i -> i * i end)
[0, 1, 4, 9]

iex> RList.fill(~w[a b c d], fn _, i -> i * 2 end, 0..1)
[0, 2, "c", "d"]
```

### dig/3

Finds and returns the element in nested elements that is specified by index and identifiers.

```elixir
iex> [:foo, [:bar, :baz, [:bat, :bam]]]
iex> |> RList.dig(1)
[:bar, :baz, [:bat, :bam]]

iex> [:foo, [:bar, :baz, [:bat, :bam]]]
iex> |> RList.dig(1, [2])
[:bat, :bam]

iex> [:foo, [:bar, :baz, [:bat, :bam]]]
iex> |> RList.dig(1, [2, 0])
:bat

iex> [:foo, [:bar, :baz, [:bat, :bam]]]
iex> |> RList.dig(1, [2, 3])
nil
```

### intersection/2

Returns a new list containing each element found both in list1 and in all of the given list2; duplicates are omitted.

```elixir
iex> [1, 2, 3]
iex> |> RList.intersection([3, 4, 5])
[3]

iex> [1, 2, 3]
iex> |> RList.intersection([5, 6, 7])
[]

iex> [1, 2, 3]
iex> |> RList.intersection([1, 2, 3])
[1, 2, 3]
"""
```

### sample/2

Returns one or more random elements.

### values_at/1

Returns a list containing the elements in list corresponding to the given selector(s).The selectors may be either integer indices or ranges.

```elixir
iex> RList.values_at(~w[a b c d e f], [1, 3, 5])
["b", "d", "f"]

iex> RList.values_at(~w[a b c d e f], [1, 3, 5, 7])
["b", "d", "f", nil]

iex> RList.values_at(~w[a b c d e f], [-1, -2, -2, -7])
["f", "e", "e", nil]

iex> RList.values_at(~w[a b c d e f], [4..6, 3..5])
["e", "f", nil, "d", "e", "f"]

iex> RList.values_at(~w[a b c d e f], 4..6)
["e", "f", nil]
```

### second/1

Equal to `Enum.at(list, 1)`.

```elixir
iex> ~w[a b c d]
iex> |> RList.second()
"b"
# See also RList.ActiveSupport.third, RList.ActiveSupport.fourth, RList.ActiveSupport.fifth and RList.ActiveSupport.forty_two
```

### from/2

Returns the tail of the list from position.

```elixir
iex> ~w[a b c d]
iex> |> RList.from(0)
["a", "b", "c", "d"]

iex> ~w[a b c d]
iex> |> RList.from(2)
["c", "d"]

iex> ~w[a b c d]
iex> |> RList.from(10)
[]

iex> ~w[]
iex> |> RList.from(0)
[]

iex> ~w[a b c d]
iex> |> RList.from(-2)
["c", "d"]

iex> ~w[a b c d]
iex> |> RList.from(-10)
[]
# See also RList.ActiveSupport.to
```

### to_sentence/2

Converts the list to a comma-separated sentence where the last element is joined by the connector word.

You can pass the following options to change the default behavior. If you pass an option key that doesn't exist in the list below, it will raise an

**Options**

- `:words_connector` - The sign or word used to join all but the last
  element in lists with three or more elements (default: ", ").
- `:last_word_connector` - The sign or word used to join the last element
  in lists with three or more elements (default: ", and ").
- `:two_words_connector` - The sign or word used to join the elements
  in lists with two elements (default: " and ").

```elixir
iex> ["one", "two"]
iex> |> RList.to_sentence()
"one and two"

iex> ["one", "two", "three"]
iex> |> RList.to_sentence()
"one, two, and three"

iex> ["one", "two"]
iex> |> RList.to_sentence(two_words_connector: "-")
"one-two"

iex> ["one", "two", "three"]
iex> |> RList.to_sentence(words_connector: " or ", last_word_connector: " or at least ")
"one or two or at least three"

iex> ["one", "two", "three"]
iex> |> RList.to_sentence()
"one, two, and three"
```

### new/2

Make a list of size amount.

```elixir
iex> 1
iex> |> RList.new(3)
[1, 1, 1]
```

## About [RMap](https://hexdocs.pm/r_enum/RMap.html)

RMap is Map extended with convenient functions inspired by Ruby and Rails ActiveSupport.
**All the functions are available defined in**

- [Map](https://hexdocs.pm/r_enum/RMap.Native.html)
- [REnum](https://hexdocs.pm/r_enum/REnum.html)
- [RMap.Ruby](https://hexdocs.pm/r_enum/RMap.Ruby.html)
- [RMap.ActiveSupport](https://hexdocs.pm/r_enum/RMap.ActiveSupport.html)
- [RMap.Support](https://hexdocs.pm/r_enum/RMap.Support.html)

### dig/2

Returns the object in nested map that is specified by a given key and additional arguments.

```elixir
iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :b, :c])
1

iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :c, :b])
nil
```

### each_key/2

Calls the function with each key; returns :ok.

```elixir
iex> RMap.each_key(%{a: 1, b: 2, c: 3}, &IO.inspect(&1))
# :a
# :b
# :c
:ok
# See also RMap.Ruby.each_value, RMap.Ruby.each_pair
```

### except/2

Returns a map excluding entries for the given keys.

```elixir
iex> RMap.except(%{a: 1, b: 2, c: 3}, [:a, :b])
%{c: 3}
```

### invert/1

Returns a map object with the each key-value pair inverted.

```elixir
iex> RMap.invert(%{"a" => 0, "b" => 100, "c" => 200, "d" => 300, "e" => 300})
%{0 => "a", 100 => "b", 200 => "c", 300 => "e"}

iex> RMap.invert(%{a: 1, b: 1, c: %{d: 2}})
%{1 => :b, %{d: 2} => :c}
```

### values_at/2

Returns a list containing values for the given keys.

```elixir
iex> RMap.values_at(%{a: 1, b: 2, c: 3}, [:a, :b, :d])
[1, 2, nil]
```

### deep_atomize_keys/1

Returns a list with all keys converted to atom.
This includes the keys from the root map and from all nested maps and arrays.

```elixir
iex> RMap.deep_atomize_keys(%{"name" => "Rob", "years" => "28", "nested" => %{ "a" => 1 }})
%{name: "Rob", nested: %{a: 1}, years: "28"}

iex> RMap.deep_atomize_keys(%{"a" => %{"b" => %{"c" => 1}, "d" => [%{"a" => 1, "b" => %{"c" => 2}}]}})
%{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}}
# See also RList.ActiveSupport.deep_symbolize_keys, RList.ActiveSupport.symbolize_keys, RList.ActiveSupport.deep_stringify_keys, RList.ActiveSupport.stringify_keys,
```

### deep_transform_keys/2

Returns a list with all keys converted to atom.
This includes the keys from the root map and from all nested maps and arrays.

```elixir
iex> RMap.deep_transform_keys(%{a: %{b: %{c: 1}}}, &to_string(&1))
%{"a" => %{"b" => %{"c" => 1}}}

iex> RMap.deep_transform_keys(%{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}}, &inspect(&1))
%{":a" => %{":b" => %{":c" => 1}, ":d" => [%{":a" => 1, ":b" => %{":c" => 2}}]}}
# See also RList.ActiveSupport.deep_transform_values
```

## About [RRange](https://hexdocs.pm/r_enum/RRange.html)

**All the functions are available defined in**

- [Range](https://hexdocs.pm/r_enum/RRange.Native.html)
- [RRange.Ruby](https://hexdocs.pm/r_enum/RRange.Ruby.html)
- [RRange.ActiveSupport](https://hexdocs.pm/r_enum/RRange.ActiveSupport.html)
- [REnum](https://hexdocs.pm/r_enum/REnum.html)

### begin/1

Returns the first element of range.

```elixir
iex> RList.begin(1..3)
1
# See also RRange.Ruby.end
```

### step/2

Returns Stream that from given range split into by given step.

```elixir
iex> RList.step(1..10, 2)
iex> |> Enum.to_list()
[1, 3, 5, 7, 9]
"""
```

### overlaps?/2

Compare two ranges and see if they overlap each other.

```elixir
iex> RList.overlaps?(1..5, 4..6)
true

iex> RList.overlaps?(1..5, 7..9)
false
```

## About [RUtils](https://hexdocs.pm/r_enum/RUtils.html)

Some useful functions.

### blank?/1

Return true if object is blank, false, empty, or a whitespace string.
For example, +nil+, '', '   ', [], {}, and +false+ are all blank.

```elixir
iex>  RUtils.blank?(%{})
true

iex> RUtils.blank?([1])
false

iex> RUtils.blank?("  ")
true
```

### present?/1

Returns true if not `RUtils.blank?`

```elixir
iex> RUtils.present?(%{})
false

iex> RUtils.present?([1])
true

iex> RUtils.present?("  ")
false
```

### define_all_functions!/2

Defines in the module that called all the functions of the argument module.

```elixir
iex> defmodule A do
...>   defmacro __using__(_opts) do
...>     RUtils.define_all_functions!(__MODULE__)
...>   end
...>
...>   def test do
...>     :test
...>   end
...> end
iex> defmodule B do
...>   use A
...> end
iex> B.test
:test
```

## Progress

| REnum   | Elixir Module | Ruby Class       | Elixir | Ruby | ActiveSupport |
| ------- | ------------- | ---------------- | :----: | :--: | :-----------: |
| REnum   | Enum          | Enumerable       |   ✅   |  ✅  |      ✅       |
| RList   | List          | Array            |   ✅   |  ✅  |      ✅       |
| RMap    | Map           | Hash             |   ✅   |  ✅  |      ✅       |
| RRange  | Range         | Range            |   ✅   |  ✅  |      ✅       |
| RStream | Stream        | Enumerator::Lazy |   ✅   | TODO |     TODO      |
