defmodule RList.Ruby do
  @moduledoc """
  Summarized all of Ruby's Array functions.
  Functions corresponding to the following patterns are not implemented
   - When a function with the same name already exists in Elixir.
   - When a method name includes `!`.
   - &, *, +, -, <<, <=>, ==, [], []=.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  import REnum.Support

  # https://ruby-doc.org/core-3.1.0/Array.html
  # [:all?, :any?, :append, :assoc, :at, :bsearch, :bsearch_index, :clear, :collect, :collect!, :combination, :compact, :compact!, :concat, :count, :cycle, :deconstruct, :delete, :delete_at, :delete_if, :difference, :dig, :drop, :drop_while, :each, :each_index, :empty?, :eql?, :fetch, :fill, :filter, :filter!, :find_index, :first, :flatten, :flatten!, :hash, :include?, :index, :initialize_copy, :insert, :inspect, :intersect?, :intersection, :join, :keep_if, :last, :length, :map, :map!, :max, :min, :minmax, :none?, :old_to_s, :one?, :pack, :permutation, :pop, :prepend, :product, :push, :rassoc, :reject, :reject!, :repeated_combination, :repeated_permutation, :replace, :reverse, :reverse!, :reverse_each, :rindex, :rotate, :rotate!, :sample, :select, :select!, :shift, :shuffle, :shuffle!, :size, :slice, :slice!, :sort, :sort!, :sort_by!, :sum, :take, :take_while, :to_a, :to_ary, :to_h, :to_s, :transpose, :union, :uniq, :uniq!, :unshift, :values_at, :zip]
  # |> RUtils.required_functions([List, REnum])
  # ✔ append
  # ✔ assoc
  # bsearch
  # bsearch_index
  # ✔ clear
  # combination
  # deconstruct
  # ✔ delete_if
  # ✔ difference
  # ✔ dig
  # ✔ each_index
  # ✔ eql?
  # ✔ fill
  # hash
  # ✔ index
  # × initialize_copy
  # ✔ insert
  # ✔ inspect
  # ✔ intersect?
  # ✔ intersection
  # ✔ keep_if
  # ✔ length
  # × old_to_s
  # pack
  # permutation
  # pop
  # prepend
  # ✔ push
  # rassoc
  # repeated_combination
  # repeated_permutation
  # × replace
  # ✔ rindex
  # ✔ rotate
  # ✔ sample
  # ✔ shift
  # ✔ size
  # ✔ to_ary
  # ✔ to_s
  # ✔ transpose
  # ✔ union
  # ✔ unshift
  # ✔ values_at

  def push(list, elements_or_element) do
    list ++ List.wrap(elements_or_element)
  end

  def assoc(list, key) do
    list
    |> Enum.find(fn els ->
      [head | _] = els |> Enum.to_list()
      head == key
    end)
  end

  def clear(list) when is_list(list), do: []

  def difference(list1, list2) do
    list1 -- list2
  end

  def dig(list, index, identifiers \\ []) do
    el = Enum.at(list, index)

    if(Enum.any?(identifiers)) do
      [next_index | next_identifiers] = identifiers
      dig(el, next_index, next_identifiers)
    else
      el
    end
  end

  def index(list, func_or_pattern) when is_function(func_or_pattern) do
    Enum.find_index(list, func_or_pattern)
  end

  def index(list, func_or_pattern) do
    index(list, match_function(func_or_pattern))
  end

  def eql?(list1, list2) do
    list1 == list2
  end

  def intersect?(list1, list2) do
    intersection(list1, list2)
    |> Enum.count() > 0
  end

  def intersection(list1, list2) do
    m1 = MapSet.new(list1)
    m2 = MapSet.new(list2)

    MapSet.intersection(m1, m2)
    |> Enum.to_list()
  end

  def sample(list, n \\ 1) do
    taked =
      list
      |> Enum.shuffle()
      |> Enum.take(n)

    if(taked |> Enum.count() > 1) do
      taked
    else
      [head | _] = taked
      head
    end
  end

  @doc """
  Fills the list with the provided value. The filler can be either a function or a fixed value.

  ## Examples
      iex> RList.fill(~w[a b c d], "x")
      ["x", "x", "x", "x"]

      iex> RList.fill(~w[a b c d], "x", 0..1)
      ["x", "x", "c", "d"]

      iex> RList.fill(~w[a b c d], fn _, i -> i * i end)
      [0, 1, 4, 9]

      iex> RList.fill(~w[a b c d], fn _, i -> i * 2 end, 0..1)
      [0, 2, "c", "d"]
  """
  @spec fill([any], any) :: [any]
  def fill(list, filler_fun) when is_function(filler_fun) do
    Enum.with_index(list, filler_fun)
  end

  def fill(list, filler), do: Enum.map(list, fn _ -> filler end)

  @spec fill([any], any, Range.t()) :: [any]
  def fill(list, filler_fun, a..b) when is_function(filler_fun) do
    Enum.with_index(list, fn
      x, i when i >= a and i <= b -> filler_fun.(x, i)
      x, _i -> x
    end)
  end

  def fill(list, filler, fill_range), do: fill(list, fn _, _ -> filler end, fill_range)

  @doc """
  Returns a list containing the elements in self corresponding to the given selector(s).
  The selectors may be either integer indices or ranges.

  ## Examples

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
  """
  @spec values_at([any], [integer | Range.t()] | Range.t()) :: [any]
  def values_at(list, indices) do
    indices
    |> Enum.map(fn
      i when is_integer(i) -> i
      i -> Enum.to_list(i)
    end)
    |> List.flatten()
    |> Enum.map(&Enum.at(list, &1))
  end

  @doc """
  Returns a new list by joining two lists, excluding any duplicates and preserving the order from the given lists.
  ## Examples
      iex> RList.union(["a", "b", "c"], [ "c", "d", "a"])
      ["a", "b", "c", "d"]

      iex> ["a"] |> RList.union(["e", "b"]) |> RList.union(["a", "c", "b"])
      ["a", "e", "b", "c"]
  """
  @spec union([any], [any]) :: [any]
  def union(list_a, list_b), do: Enum.uniq(list_a ++ list_b)

  @doc """
  Prepends elements to the front of the list, moving other elements upwards.
  ## Examples
      iex> RList.unshift(~w[b c d], "a")
      ["a", "b", "c", "d"]

      iex> RList.unshift(~w[b c d], [1, 2])
      [1, 2, "b", "c", "d"]
  """
  @spec unshift([any], any) :: [any]
  def unshift(list, prepend) when is_list(prepend), do: prepend ++ list
  def unshift(list, prepend), do: [prepend | list]

  @doc """
  Splits the list into the first n elements and the rest. Returns nil if the list is empty.
  ## Examples
      iex> RList.shift([])
      nil

      iex> RList.shift(~w[-m -q -filename])
      {["-m"], ["-q", "-filename"]}

      iex> RList.shift(~w[-m -q -filename], 2)
      {["-m", "-q"], ["-filename"]}
  """
  @spec shift([any], integer) :: {[any], [any]} | nil
  def shift(list, count \\ 1)
  def shift([], _count), do: nil
  def shift(list, count), do: Enum.split(list, count)

  @doc """
  Returns the index of the last element found in in the list. Returns nil if no match is found.
  ## Examples
      iex> RList.rindex(~w[a b b b c], "b")
      3

      iex> RList.rindex(~w[a b b b c], "z")
      nil

      iex> RList.rindex(~w[a b b b c], fn x -> x == "b" end)
      3
  """
  @spec rindex([any], any) :: integer | nil
  def rindex(list, finder) when is_function(finder) do
    list
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.find_value(fn {x, i} -> finder.(x) && i end)
  end

  def rindex(list, finder), do: rindex(list, &Kernel.==(&1, finder))

  @doc """
  Rotate the list so that the element at count is the first element of the list.

  ## Examples
      iex> RList.rotate(~w[a b c d])
      ["b", "c", "d", "a"]

      iex> RList.rotate(~w[a b c d], 2)
      ["c", "d", "a", "b"]

      iex> RList.rotate(~w[a b c d], -3)
      ["b", "c", "d", "a"]
  """
  @spec rotate([any], integer) :: [any]
  def rotate(list, count \\ 1) do
    {first, last} = Enum.split(list, count)
    last ++ first
  end

  def to_ary(list), do: list

  # TODO: hard
  # def combination(list, n) do
  #   []
  # end
  # def combination(list, n, func) do
  #   combination(list, n)
  #   |> func.()
  # end

  defdelegate append(list, elements), to: __MODULE__, as: :push
  defdelegate delete_if(list, func), to: Enum, as: :reject
  defdelegate keep_if(list, func), to: Enum, as: :filter
  defdelegate length(list), to: Enum, as: :count
  defdelegate size(list), to: Enum, as: :count
  defdelegate to_s(list), to: Kernel, as: :inspect
  defdelegate inspect(list), to: Kernel, as: :inspect
  defdelegate each_index(list, func), to: Enum, as: :with_index
  defdelegate insert(list, index, element), to: List, as: :insert_at
  defdelegate transpose(list_of_lists), to: List, as: :zip
end
