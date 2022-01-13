defmodule REnum.Enumerable.Ruby do
  @moduledoc """
  Summarized all of Ruby functions.
  If a function with the same name already exists in Elixir, that is not implemented.
  Also, the function that returns Enumerator in Ruby is customized each behavior on the characteristics.
  Defines all of here functions when `use REnum.Enumerable.Ruby`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(__MODULE__)
  end

  import REnum.Enumerable.Support

  # https://ruby-doc.org/core-3.1.0/Enumerable.html
  # ruby_enumerable = [:all?, :any?, :chain, :chunk, :chunk_while, :collect, :collect_concat, :compact, :count, :cycle, :detect, :drop, :drop_while, :each_cons, :each_entry, :each_slice, :each_with_index, :each_with_object, :entries, :filter, :filter_map, :find, :find_all, :find_index, :first, :flat_map, :grep, :grep_v, :group_by, :include?, :inject, :lazy, :map, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :none?, :one?, :partition, :reduce, :reject, :reverse_each, :select, :slice_after, :slice_before, :slice_when, :sort, :sort_by, :sum, :take, :take_while, :tally, :to_a, :to_h, :uniq, :zip]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # ✔ chain
  # ✔ collect
  # ✔ collect_concat
  # ✔ compact
  # ✔ cycle
  # ✔ detect
  # ✔ each_cons
  # ✔ each_entry
  # ✔ each_slice
  # ✔ each_with_index
  # ✔ each_with_object
  # ✔ entries
  # ✔ find_all
  # ✔ first
  # ✔ grep
  # ✔ grep_v
  # ✔ include?
  # ✔ inject
  # ✔ lazy
  # ✔ minmax
  # ✔ minmax_by
  # ✔ none?
  # ✔ one?
  # ✔ reverse_each
  # ✔ select
  # ✔ slice_after
  # ✔ slice_before
  # ✔ slice_when
  # ✔ tally
  # ✔ to_a
  # ✔ to_h

  @doc """
  Returns an list of all non-nil elements.
  ## Examples
      iex> REnum.compact([1, nil, 2, 3])
      [1, 2, 3]
      iex> REnum.compact(%{
      ...>        :truthy => true,
      ...>        false => false,
      ...>        nil => nil,
      ...>        nil => true,
      ...>        :map => %{key: :value}
      ...>      })
      %{
          :truthy => true,
          false => false,
          nil => true,
          :map => %{key: :value}
        }
  """
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

  @doc """
  Returns the first element.
  ## Examples
      iex> REnum.first([1, 2, 3])
      1
      iex> REnum.first(%{a: 1, b: 2})
      [:a, 1]
  """
  def first(enumerable) do
    result = Enum.at(enumerable, 0)

    cond do
      result |> is_nil() -> nil
      result |> is_tuple() -> result |> Tuple.to_list()
      true -> result
    end
  end

  @doc """
  Returns leading elements.
  ## Examples
      iex> REnum.first([1, 2, 3], 2)
      [1, 2]
      iex> REnum.first(%{a: 1, b: 2}, 2)
      [[:a, 1], [:b, 2]]
  """
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

  def one?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) == 1
  end

  def none?(enumerable) do
    truthy_count(enumerable) == 0
  end

  def none?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) == 0
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

  def chain(enumerable_1, enumerable_2) do
    Stream.concat([enumerable_1, enumerable_2])
  end

  def each_entry(enumerable, func) do
    enumerable
    |> Enum.each(func)

    enumerable
  end

  def each_slice(enumerable, amount, func) do
    enumerable
    |> each_slice(
      0,
      amount,
      func
    )

    enumerable
  end

  defp each_slice(enumerable, start_index, amount, func) do
    enumerable
    |> Enum.slice(start_index, amount)
    |> func.()

    next_start_index = start_index + amount

    if(Enum.count(enumerable) > next_start_index) do
      each_slice(enumerable, next_start_index, amount, func)
    end
  end

  def lazy(enumerable) do
    enumerable
    |> chain([])
    |> Stream.take(Enum.count(enumerable))
  end

  def slice_after(enumerable, func) when is_function(func) do
    if(Enum.count(enumerable) < 1) do
      enumerable
    else
      index =
        enumerable
        |> Enum.find_index(func) ||
          Enum.count(enumerable)

      [Enum.slice(enumerable, 0..index)] ++
        slice_after(
          Enum.slice(enumerable, (index + 1)..Enum.count(enumerable)),
          func
        )
    end
  end

  def slice_after(enumerable, pattern) do
    slice_after(
      enumerable,
      match_function(pattern)
    )
  end

  def slice_before(enumerable, func) when is_function(func) do
    enumerable
    |> Enum.reverse()
    |> slice_after(func)
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse(&1))
  end

  def slice_before(enumerable, pattern) do
    enumerable
    |> Enum.reverse()
    |> slice_after(match_function(pattern))
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse(&1))
  end

  def slice_when(enumerable, func) do
    if(Enum.count(enumerable) < 1) do
      enumerable
    else
      index =
        enumerable
        |> find_index_with_index(fn el, index ->
          next_el = Enum.at(enumerable, index + 1)
          func.(el, next_el)
        end) ||
          Enum.count(enumerable)

      [Enum.slice(enumerable, 0..index)] ++
        slice_when(
          Enum.slice(enumerable, (index + 1)..Enum.count(enumerable)),
          func
        )
    end
  end

  def grep(enumerable, func) when is_function(func) do
    enumerable
    |> select(func)
  end

  def grep(enumerable, pattern) do
    grep(
      enumerable,
      match_function(pattern)
    )
  end

  def grep(enumerable, pattern, func) do
    enumerable
    |> grep(pattern)
    |> Enum.map(func)
  end

  def grep_v(enumerable, pattern) do
    greped = enumerable |> grep(pattern)

    enumerable
    |> Enum.reject(&(&1 in greped))
  end

  def grep_v(enumerable, pattern, func) do
    enumerable
    |> grep_v(pattern)
    |> Enum.map(func)
  end

  def tally(enumerable) do
    enumerable
    |> Enum.group_by(& &1)
    |> Enum.map(fn el ->
      {elem(el, 0), elem(el, 1) |> Enum.count()}
    end)
    |> Map.new()
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
  defdelegate each_with_index(enumerable, func), to: Enum, as: :with_index
  defdelegate each_with_index(enumerable), to: Enum, as: :with_index
  defdelegate minmax(enumerable), to: Enum, as: :min_max
  defdelegate minmax(enumerable, func), to: Enum, as: :min_max
  defdelegate minmax_by(enumerable, func), to: Enum, as: :min_max_by
  defdelegate minmax_by(enumerable, func1, func2), to: Enum, as: :min_max_by
  defdelegate minmax_by(enumerable, func1, func2, func3), to: Enum, as: :min_max_by
end
