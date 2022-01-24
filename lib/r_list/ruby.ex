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

  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()

  import REnum.Support

  # https://ruby-doc.org/core-3.1.0/Array.html
  # [:all?, :any?, :append, :assoc, :at, :bsearch, :bsearch_index, :clear, :collect, :collect!, :combination, :compact, :compact!, :concat, :count, :cycle, :deconstruct, :delete, :delete_at, :delete_if, :difference, :dig, :drop, :drop_while, :each, :each_index, :empty?, :eql?, :fetch, :fill, :filter, :filter!, :find_index, :first, :flatten, :flatten!, :hash, :include?, :index, :initialize_copy, :insert, :inspect, :intersect?, :intersection, :join, :keep_if, :last, :length, :map, :map!, :max, :min, :minmax, :none?, :old_to_s, :one?, :pack, :permutation, :pop, :prepend, :product, :push, :rassoc, :reject, :reject!, :repeated_combination, :repeated_permutation, :replace, :reverse, :reverse!, :reverse_each, :rindex, :rotate, :rotate!, :sample, :select, :select!, :shift, :shuffle, :shuffle!, :size, :slice, :slice!, :sort, :sort!, :sort_by!, :sum, :take, :take_while, :to_a, :to_ary, :to_h, :to_s, :transpose, :union, :uniq, :uniq!, :unshift, :values_at, :zip]
  # |> RUtils.required_functions([List, REnum])
  # ✔ append
  # ✔ assoc
  # × bsearch
  # × bsearch_index
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
  # ✔ pop
  # ✔ prepend
  # ✔ push
  # ✔ rassoc
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

  @doc """
  Appends trailing elements.

  ## Examples
      iex> [:foo, 'bar', 2]
      iex> |> RList.push([:baz, :bat])
      [:foo, 'bar', 2, :baz, :bat]

      iex> [:foo, 'bar', 2]
      iex> |> RList.push(:baz)
      [:foo, 'bar', 2, :baz]
  """
  @spec push(list(), list() | any) :: list()
  def push(list, elements_or_element) do
    list ++ List.wrap(elements_or_element)
  end

  @doc """
  Returns [].

  ## Examples
      iex> [[:foo, 0], [2, 4], [4, 5, 6], [4, 5]]
      iex> |> RList.clear()
      []
  """
  @spec clear(list()) :: []
  def clear(list) when is_list(list), do: []

  @doc """
  Returns differences between list1 and list2.

  ## Examples
      iex> [0, 1, 1, 2, 1, 1, 3, 1, 1]
      iex> |> RList.difference([1])
      [0, 2, 3]

      iex> [0, 1, 2]
      iex> |> RList.difference([4])
      [0, 1, 2]
  """
  @spec difference(list(), list()) :: list()
  def difference(list1, list2) do
    list1
    |> Enum.reject(fn el ->
      el in list2
    end)
  end

  @doc """
  Finds and returns the element in nested elements that is specified by index and identifiers.

  ## Examples
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
  """
  @spec dig(list(), integer, list()) :: any
  def dig(list, index, identifiers \\ []) do
    el = Enum.at(list, index)

    if(Enum.any?(identifiers)) do
      [next_index | next_identifiers] =
        identifiers
        |> IO.inspect()

      dig(el, next_index, next_identifiers)
    else
      el
    end
  end

  @doc """
  Returns the index of a specified element.

  ## Examples
      iex> [:foo, "bar", 2, "bar"]
      iex> |> RList.index("bar")
      1

      iex> [2, 4, 6, 8]
      iex> |> RList.index(5..7)
      2

      iex> [2, 4, 6, 8]
      iex> |> RList.index(&(&1 == 8))
      3
  """
  @spec index(list(), type_pattern | function()) :: any
  def index(list, func_or_pattern) when is_function(func_or_pattern) do
    Enum.find_index(list, func_or_pattern)
  end

  def index(list, func_or_pattern) do
    index(list, match_function(func_or_pattern))
  end

  @doc """
  Returns true if list1 == list2.

  ## Examples
      iex>  [:foo, 'bar', 2]
      iex> |> RList.eql?([:foo, 'bar', 2])
      true

      iex>  [:foo, 'bar', 2]
      iex> |> RList.eql?([:foo, 'bar', 3])
      false
  """
  @spec eql?(list(), list()) :: boolean()
  def eql?(list1, list2) do
    list1 == list2
  end

  @doc """
  Returns true if the list1 and list2 have at least one element in common, otherwise returns false.

  ## Examples
      iex> [1, 2, 3]
      iex> |> RList.intersect?([3, 4, 5])
      true

      iex> [1, 2, 3]
      iex> |> RList.intersect?([5, 6, 7])
      false
  """
  @spec intersect?(list(), list()) :: boolean()
  def intersect?(list1, list2) do
    intersection(list1, list2)
    |> Enum.count() > 0
  end

  @doc """
  Returns a new list containing each element found both in list1 and in all of the given list2; duplicates are omitted.

  ## Examples
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
  @spec intersection(list(), list()) :: list()
  def intersection(list1, list2) do
    m1 = MapSet.new(list1)
    m2 = MapSet.new(list2)

    MapSet.intersection(m1, m2)
    |> Enum.to_list()
  end

  @doc """
  Returns one or more random elements.
  """
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
  @spec fill(list(), any) :: list()
  def fill(list, filler_fun) when is_function(filler_fun) do
    Enum.with_index(list, filler_fun)
  end

  def fill(list, filler), do: Enum.map(list, fn _ -> filler end)

  @spec fill(list(), any, Range.t()) :: list()
  def fill(list, filler_fun, a..b) when is_function(filler_fun) do
    Enum.with_index(list, fn
      x, i when i >= a and i <= b -> filler_fun.(x, i)
      x, _i -> x
    end)
  end

  def fill(list, filler, fill_range), do: fill(list, fn _, _ -> filler end, fill_range)

  @doc """
  Returns a list containing the elements in list corresponding to the given selector(s).
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
  @spec values_at(list(), [integer | Range.t()] | Range.t()) :: list()
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
  @spec union(list(), list()) :: list()
  def union(list_a, list_b), do: Enum.uniq(list_a ++ list_b)

  @doc """
  Prepends elements to the front of the list, moving other elements upwards.
  ## Examples
      iex> RList.unshift(~w[b c d], "a")
      ["a", "b", "c", "d"]

      iex> RList.unshift(~w[b c d], [1, 2])
      [1, 2, "b", "c", "d"]
  """
  @spec unshift(list(), any) :: list()
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
  @spec shift(list(), integer) :: {list(), list()} | nil
  def shift(list, count \\ 1)
  def shift([], _count), do: nil
  def shift(list, count), do: Enum.split(list, count)

  @doc """
  Splits the list into the last n elements and the rest. Returns nil if the list is empty.
  ## Examples
      iex> RList.pop([])
      nil

      iex> RList.pop(~w[-m -q -filename test.txt])
      {["test.txt"], ["-m", "-q", "-filename"]}

      iex> RList.pop(~w[-m -q -filename test.txt], 2)
      {["-filename", "test.txt"], ["-m", "-q"]}
  """
  @spec pop(list(), integer) :: {list(), list()} | nil
  def pop(list, count \\ 1) do
    list
    |> Enum.reverse()
    |> shift(count)
    |> _pop()
  end

  defp _pop(nil), do: nil

  defp _pop(tuple) do
    {
      elem(tuple, 0) |> Enum.reverse(),
      elem(tuple, 1) |> Enum.reverse()
    }
  end

  @doc """
  Returns the first element that is a List whose last element `==` the specified term.

  ## Examples

      iex> [{:foo, 0}, [2, 4], [4, 5, 6], [4, 5]]
      iex> |> RList.rassoc(4)
      [2, 4]

      iex> [{:foo, 0}, [2, 4], [4, 5, 6], [4, 5]]
      iex> |> RList.rassoc(0)
      {:foo, 0}

      iex> [[1, "one"], [2, "two"], [3, "three"], ["ii", "two"]]
      iex> |> RList.rassoc("two")
      [2, "two"]

      iex> [[1, "one"], [2, "two"], [3, "three"], ["ii", "two"]]
      iex> |> RList.rassoc("four")
      nil

      iex> [] |> RList.rassoc(4)
      nil

      iex> [[]] |> RList.rassoc(4)
      nil

      iex> [{}] |> RList.rassoc(4)
      nil
  """
  @spec rassoc([list | tuple], any) :: list | nil
  def rassoc(list, key) do
    Enum.find(list, fn
      nil -> nil
      [] -> nil
      {} -> nil
      x when is_tuple(x) -> x |> Tuple.to_list() |> Enum.reverse() |> hd() == key
      x -> x |> Enum.reverse() |> hd() == key
    end)
  end

  @doc """
  Returns the first element in list that is an List whose first key == obj:

  ## Examples
      iex> [{:foo, 0}, [2, 4], [4, 5, 6], [4, 5]]
      iex> |> RList.assoc(4)
      [4, 5, 6]

      iex> [[:foo, 0], [2, 4], [4, 5, 6], [4, 5]]
      iex> |> RList.assoc(1)
      nil

      iex> [[:foo, 0], [2, 4], %{a: 4, b: 5, c: 6}, [4, 5]]
      iex> |> RList.assoc({:a, 4})
      %{a: 4, b: 5, c: 6}
  """
  @spec assoc(list(), any) :: any
  def assoc(list, key) do
    list
    |> Enum.find(fn
      nil -> nil
      [] -> nil
      {} -> nil
      x when is_tuple(x) -> x |> Tuple.to_list() |> hd() == key
      x -> x |> Enum.to_list() |> hd() == key
    end)
  end

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
  @spec rindex(list(), any) :: integer | nil
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
  @spec rotate(list(), integer) :: list()
  def rotate(list, count \\ 1) do
    {first, last} = Enum.split(list, count)
    last ++ first
  end

  @doc """
  Returns list.

  ## Examples
      iex> RList.to_ary(["b", "c", "d", "a"])
      ["b", "c", "d", "a"]

      iex> RList.to_ary(["c", "d", "a", "b"])
      ["c", "d", "a", "b"]
  """
  @spec to_ary(list()) :: list()
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
  defdelegate prepend(list, count \\ 1), to: __MODULE__, as: :shift
end
