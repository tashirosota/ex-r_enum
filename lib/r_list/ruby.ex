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
  # delete_if
  # ✔ difference
  # ✔ dig
  # each_index
  # eql?
  # fill
  # hash
  # index
  # initialize_copy
  # insert
  # inspect
  # intersect?
  # intersection
  # keep_if
  # length
  # old_to_s
  # pack
  # permutation
  # pop
  # prepend
  # push
  # rassoc
  # repeated_combination
  # repeated_permutation
  # replace
  # rindex
  # rotate
  # sample
  # shift
  # size
  # to_ary
  # to_s
  # transpose
  # union
  # unshift
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

  # TODO: hard
  # def combination(list, n) do
  #   []
  # end
  # def combination(list, n, func) do
  #   combination(list, n)
  #   |> func.()
  # end

  defdelegate append(list, elements), to: __MODULE__, as: :push
end
