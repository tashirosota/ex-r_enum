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

  use REnum.Ruby
  import REnum.Support

  # https://ruby-doc.org/core-3.1.0/Array.html
  # [:all?, :any?, :append, :assoc, :at, :bsearch, :bsearch_index, :clear, :collect, :collect!, :combination, :compact, :compact!, :concat, :count, :cycle, :deconstruct, :delete, :delete_at, :delete_if, :difference, :dig, :drop, :drop_while, :each, :each_index, :empty?, :eql?, :fetch, :fill, :filter, :filter!, :find_index, :first, :flatten, :flatten!, :hash, :include?, :index, :initialize_copy, :insert, :inspect, :intersect?, :intersection, :join, :keep_if, :last, :length, :map, :map!, :max, :min, :minmax, :none?, :old_to_s, :one?, :pack, :permutation, :pop, :prepend, :product, :push, :rassoc, :reject, :reject!, :repeated_combination, :repeated_permutation, :replace, :reverse, :reverse!, :reverse_each, :rindex, :rotate, :rotate!, :sample, :select, :select!, :shift, :shuffle, :shuffle!, :size, :slice, :slice!, :sort, :sort!, :sort_by!, :sum, :take, :take_while, :to_a, :to_ary, :to_h, :to_s, :transpose, :union, :uniq, :uniq!, :unshift, :values_at, :zip]
  # |> RUtils.required_functions([List, REnum.Ruby])
  # ✔ all?
  # ✔ any?
  # ✔ append
  # ✔ assoc
  # ✔ at
  # bsearch
  # bsearch_index
  # ✔ clear
  # combination
  # ✔ concat
  # ✔ count
  # deconstruct
  # ✔ delete_if
  # ✔ difference
  # dig
  # drop
  # drop_while
  # each
  # each_index
  # empty?
  # eql?
  # fetch
  # fill
  # ✔ filter
  # find_index
  # hash
  # index
  # initialize_copy
  # insert
  # inspect
  # intersect?
  # intersection
  # join
  # ✔ keep_if
  # length
  # map
  # max
  # min
  # old_to_s
  # pack
  # permutation
  # pop
  # prepend
  # product
  # push
  # rassoc
  # ✔ reject
  # repeated_combination
  # repeated_permutation
  # replace
  # reverse
  # rindex
  # rotate
  # sample
  # shift
  # shuffle
  # size
  # slice
  # sort
  # sum
  # take
  # take_while
  # to_ary
  # to_s
  # transpose
  # union
  # uniq
  # unshift
  # values_at
  def all?(list, function_or_pattern) do
    cond do
      is_function(function_or_pattern) ->
        list |> Enum.all?(function_or_pattern)

      true ->
        list |> Enum.filter(match_function(function_or_pattern)) |> Enum.count() ==
          Enum.count(list)
    end
  end

  def any?(list, function_or_pattern) do
    cond do
      is_function(function_or_pattern) ->
        list |> Enum.any?(function_or_pattern)

      true ->
        list |> Enum.filter(match_function(function_or_pattern)) |> Enum.count() > 0
    end
  end

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

  def concat(list, lists) do
    (list ++ List.wrap(lists))
    |> List.flatten()
  end

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

  # TODO: hard
  # def combination(list, n) do
  #   []
  # end
  # def combination(list, n, func) do
  #   combination(list, n)
  #   |> func.()
  # end

  defdelegate all?(list), to: Enum
  defdelegate any?(list), to: Enum
  defdelegate append(list, elements), to: __MODULE__, as: :push
  defdelegate at(list, index), to: Enum
  defdelegate map(list, func), to: Enum
  defdelegate count(list), to: Enum
  defdelegate count(list, func), to: Enum
  defdelegate delete_if(list, func), to: Enum, as: :reject
  defdelegate reject(list, func), to: Enum
  defdelegate keep_if(list, func), to: Enum, as: :filter
  defdelegate filter(list, func), to: Enum
end
