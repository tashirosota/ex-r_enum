defmodule REnum.Enumerable.Ruby do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(__MODULE__)
  end

  # https://ruby-doc.org/core-3.1.0/Enumerable.html
  # ruby_enumerable = [:all?, :any?, :chain, :chunk, :chunk_while, :collect, :collect_concat, :compact, :count, :cycle, :detect, :drop, :drop_while, :each_cons, :each_entry, :each_slice, :each_with_index, :each_with_object, :entries, :filter, :filter_map, :find, :find_all, :find_index, :first, :flat_map, :grep, :grep_v, :group_by, :include?, :inject, :lazy, :map, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :none?, :one?, :partition, :reduce, :reject, :reverse_each, :select, :slice_after, :slice_before, :slice_when, :sort, :sort_by, :sum, :take, :take_while, :tally, :to_a, :to_h, :uniq, :zip]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # chain
  # ✔ collect
  # ✔ collect_concat
  # ✔ compact
  # ✔ cycle
  # ✔ detect
  # each_cons
  # each_entry
  # each_slice
  # each_with_index
  # each_with_object
  # entries
  # ✔ find_all
  # ✔ first
  # grep
  # grep_v
  # ✔ include?
  # ✔ inject
  # lazy
  # minmax
  # minmax_by
  # ✔ none?
  # ✔ one?
  # reverse_each
  # ✔ select
  # slice_after
  # slice_before
  # slice_when
  # tally
  # to_a
  # to_h

  def compact(enumerable) when is_list(enumerable) do
    enumerable
    |> Enum.reject(&(&1 |> is_nil()))
  end

  def compact(enumerable) when is_map(enumerable) do
    enumerable
    |> Enum.reject(fn {key, value} ->
      is_nil(key) && is_nil(value)
    end)
    |> Enum.into(%{})
  end

  def first(enumerable) do
    result = Enum.at(enumerable, 0)

    cond do
      result |> is_nil() -> nil
      result |> is_tuple() -> result |> Tuple.to_list()
      true -> result
    end
  end

  def first(enumerable, n) do
    0..(n - 1)
    |> Enum.with_index(fn _, index ->
      enumerable |> Enum.at(index)
    end)
    |> compact()
    |> Enum.map(fn el ->
      if(el |> is_tuple, do: el |> Tuple.to_list(), else: el)
    end)
  end

  def one?(enumerable) do
    truthy_count(enumerable) == 1
  end

  def one?(enumerable, func) when is_function(func) do
    truthy_count(enumerable, func) == 1
  end

  def none?(enumerable) do
    truthy_count(enumerable) == 0
  end

  def none?(enumerable, func) when is_function(func) do
    truthy_count(enumerable, func) == 0
  end

  defp truthy_count(enumerable) do
    enumerable
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  defp truthy_count(enumerable, func) when is_function(func) do
    enumerable
    |> Enum.filter(func)
    |> Enum.count()
  end

  def cycle(_, n, _) when n < 1, do: nil

  def cycle(enumerable, n, func) when is_function(func) do
    enumerable
    |> Enum.each(fn els ->
      els
      |> Enum.each(func)
    end)

    cycle(enumerable, n - 1, func)
  end

  def cycle(enumerable, func) when is_function(func) do
    Stream.iterate(enumerable, & &1)
    |> Enum.each(fn els ->
      Enum.each(els, func)
    end)
  end

  def cycle(_, n) when n < 1, do: nil

  def cycle(enumerable, _) do
    enumerable
    |> Stream.cycle()
  end

  def cycle(enumerable) do
    enumerable
    |> Stream.cycle()
  end

  # aliases

  defdelegate detect(enumerable, default, fun), to: Enum, as: :find
  defdelegate detect(enumerable, fun), to: Enum, as: :find
  defdelegate select(enumerable, fun), to: Enum, as: :filter
  defdelegate find_all(enumerable, fun), to: Enum, as: :filter
  defdelegate inject(enumerable, acc, fun), to: Enum, as: :reduce
  defdelegate inject(enumerable, fun), to: Enum, as: :reduce
  defdelegate collect(enumerable, fun), to: Enum, as: :map
  defdelegate include?(enumerable, fun), to: Enum, as: :member?
  defdelegate collect_concat(enumerable, fun), to: Enum, as: :flat_map
end
