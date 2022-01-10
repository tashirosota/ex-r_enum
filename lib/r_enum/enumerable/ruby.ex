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
  # ✔ each_cons
  # each_entry
  # each_slice
  # each_with_index
  # ✔ each_with_object
  # ✔ entries
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
  # ✔ reverse_each
  # ✔ select
  # slice_after
  # slice_before
  # slice_when
  # tally
  # ✔ to_a
  # ✔ to_h

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

  def cycle(enumerable, n, func) when is_nil(n) do
    Stream.repeatedly(fn ->
      enumerable
      |> Enum.each(func)
    end)
  end

  def cycle(_, n, _) when n < 1, do: :ok

  def cycle(enumerable, n, func) do
    enumerable
    |> Enum.each(func)

    enumerable
    |> cycle(n - 1, func)
  end

  def each_cons(_, n, _) when n < 1, do: :ok

  def each_cons(enumerable, n, func) do
    if Enum.count(enumerable) >= n do
      [_ | next_els] = enumerable |> Enum.to_list()

      enumerable
      |> Enum.take(n)
      |> func.()

      each_cons(next_els, n, func)
    end

    :ok
  end

  def to_a(enumerable) do
    cond do
      range?(enumerable) ->
        enumerable |> Enum.to_list()

      is_map(enumerable) ->
        enumerable
        |> Enum.map(fn {k, v} ->
          [k, v]
        end)

      true ->
        enumerable |> Enum.to_list()
    end
  end

  def reverse_each(enumerable, func) do
    enumerable
    |> Enum.reverse()
    |> Enum.each(func)
  end

  def to_h(enumerable) do
    if(is_list_and_not_keyword?(enumerable)) do
      enumerable
      |> Enum.map(&{Enum.at(&1, 0), Enum.at(&1, 1)})
      |> Map.new()
    else
      Map.new(enumerable)
    end
  end

  def to_h(enumerable, func) do
    Map.new(enumerable, func)
  end

  # aliases

  defdelegate detect(enumerable, default, func), to: Enum, as: :find
  defdelegate detect(enumerable, func), to: Enum, as: :find
  defdelegate select(enumerable, func), to: Enum, as: :filter
  defdelegate find_all(enumerable, func), to: Enum, as: :filter
  defdelegate inject(enumerable, acc, func), to: Enum, as: :reduce
  defdelegate inject(enumerable, func), to: Enum, as: :reduce
  defdelegate collect(enumerable, func), to: Enum, as: :map
  defdelegate include?(enumerable, func), to: Enum, as: :member?
  defdelegate collect_concat(enumerable, func), to: Enum, as: :flat_map
  defdelegate entries(enumerable), to: __MODULE__, as: :to_a
  # TODO: add info
  defdelegate each_with_object(enumerable, object, func), to: Enum, as: :reduce

  # support
  def range?(_.._), do: true
  def range?(_), do: false

  def is_list_and_not_keyword?(enumerable) do
    !Keyword.keyword?(enumerable) && is_list(enumerable)
  end
end
