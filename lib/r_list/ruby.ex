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
  # fill
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
  # rindex
  # rotate
  # ✔ sample
  # ✔ shift
  # ✔ size
  # ✔ to_ary
  # ✔ to_s
  # transpose
  # union
  # ✔ unshift
  # values_at

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
  Prepends elements to the front of the list, moving other elements upwards.
  ## Examples
      iex> RList.unshift(~w[b c d], "a")
      ["a", "b", "c", "d"]

      iex> RList.unshift(~w[b c d], [1, 2])
      [1, 2, "b", "c", "d"]
  """
  @spec unshift([any], integer) :: [any]
  def unshift(list, prepend) when is_list(prepend), do: prepend ++ list
  def unshift(list, prepend), do: [prepend | list]

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
end
