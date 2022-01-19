defmodule REnum.Ruby do
  @moduledoc """
  Summarized all of Ruby functions.
  If a function with the same name already exists in Elixir, that is not implemented.
  Also, the function that returns Enumerator in Ruby is customized each behavior on the characteristics.
  Defines all of here functions when `use REnum.Ruby`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()
  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()

  import REnum.Support

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
      ...>        :map => %{key: :value}
      ...>      })
      %{
        :truthy => true,
        false => false,
        :map => %{key: :value}
      }
  """
  @spec compact(type_enumerable) :: type_enumerable
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
      {:a, 1}
  """
  @spec first(type_enumerable) :: any()
  def first(enumerable) do
    result = Enum.at(enumerable, 0)

    cond do
      result |> is_nil() -> nil
      true -> result
    end
  end

  @doc """
  Returns leading elements.
  ## Examples
      iex> REnum.first([1, 2, 3], 2)
      [1, 2]

      iex> REnum.first(%{a: 1, b: 2}, 2)
      [{:a, 1}, {:b, 2}]
  """
  @spec first(type_enumerable, non_neg_integer()) :: type_enumerable()
  def first(enumerable, n) do
    0..(n - 1)
    |> Enum.with_index(fn _, index ->
      enumerable |> Enum.at(index)
    end)
    |> compact()
  end

  @doc """
  Return true if enumerable has only one truthy element; false otherwise.
  ## Examples
      iex> REnum.one?([1, nil, false])
      true

      iex> REnum.one?(1..4)
      false
  """
  @spec one?(type_enumerable) :: boolean()
  def one?(enumerable) do
    truthy_count(enumerable) == 1
  end

  @doc """
  Returns true if exactly one element meets a specified criterion; false otherwise.
  ## Examples
      iex> REnum.one?(1..4, 1..2)
      false

      iex> REnum.one?(1..4, &(&1 < 2))
      true

      iex> REnum.one?(1..4, 1)
      true
  """
  @spec one?(type_enumerable, function() | type_pattern) :: boolean()
  def one?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) == 1
  end

  @doc """
  Returns true if enumerable does not include truthy value; false otherwise.
  ## Examples
      iex> REnum.none?(1..4)
      false

      iex> REnum.none?([nil, false])
      true

      iex> REnum.none?([foo: 0, bar: 1])
      false
  """
  @spec none?(type_enumerable) :: boolean()
  def none?(enumerable) do
    truthy_count(enumerable) == 0
  end

  @doc """
  Returns whether no element meets a given criterion.
  ## Examples
      iex> REnum.none?(1..4, &(&1 < 1))
      true

      iex> REnum.none?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 0 end)
      true

      iex> REnum.none?(1..4, 5)
      true

      iex> REnum.none?(1..4, 2..3)
      false
  """
  @spec none?(type_enumerable, function() | type_pattern) :: boolean()
  def none?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) == 0
  end

  @doc """
  When called with positive integer argument n and a function, calls the block with each element, then does so again, until it has done so n times; returns given enumerable
  When called with a function and n is nil, returns Stream cycled forever.
  ## Examples
      iex> REnum.cycle(["a", "b"], 2, &IO.puts(&1))
      # a
      # b
      # a
      # b
      ["a", "b"]

      iex> REnum.cycle(%{a: 1, b: 2}, nil, &IO.inspect(&1)) |> Enum.take(2)
      # {:a, 1}
      # {:b, 2}
      # {:a, 1}
      # {:b, 2}
      [:ok, :ok]
  """
  @spec cycle(type_enumerable, non_neg_integer(), function()) :: Stream | type_enumerable
  def cycle(enumerable, n, func) when is_nil(n) do
    Stream.repeatedly(fn ->
      enumerable
      |> Enum.each(func)
    end)
  end

  def cycle(enumerable, n, _) when n < 1, do: enumerable

  def cycle(enumerable, n, func) do
    enumerable
    |> Enum.each(func)

    enumerable
    |> cycle(n - 1, func)
  end

  @doc """
  Calls the function with each successive overlapped n-list of elements; returns given enumerable.
  ## Examples
      iex> ["a", "b", "c", "d", "e"]
      iex> |> REnum.each_cons(3, &IO.inspect(&1))
      # ["a", "b", "c"]
      # ["b", "c", "d"]
      # ["c", "d", "e"]
      ["a", "b", "c", "d", "e"]

      iex> %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}
      iex> |> REnum.each_cons(4, &IO.inspect(&1))
      # [a: 1, b: 2, c: 3, d: 4]
      # [b: 2, c: 3, d: 4, e: 5]
      # [c: 3, d: 4, e: 5, f: 6]
      %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}
  """
  @spec each_cons(type_enumerable, integer(), function()) :: type_enumerable
  def each_cons(enumerable, n, _) when n < 1, do: enumerable

  def each_cons(enumerable, n, func) do
    if Enum.count(enumerable) >= n do
      [_ | next_els] = enumerable |> Enum.to_list()

      enumerable
      |> Enum.take(n)
      |> func.()

      each_cons(next_els, n, func)
    end

    enumerable
  end

  @doc """
  Calls the function with each element, but in reverse order; returns given enumerable.
  ## Examples
      iex> REnum.reverse_each([1, 2, 3], &IO.inspect(&1))
      # 3
      # 2
      # 1
      [1, 2, 3]
  """
  @spec reverse_each(type_enumerable(), function()) :: type_enumerable()
  def reverse_each(enumerable, func) do
    enumerable
    |> Enum.reverse()
    |> Enum.each(func)

    enumerable
  end

  @doc """
  Returns a map each of whose entries is the key-value pair formed from one of those list.
  ## Examples
      iex> REnum.to_h([[:a, 1], [:b, 2]])
      %{a: 1, b: 2}

      iex> REnum.to_h(a: 1, b: 2)
      %{a: 1, b: 2}
  """
  @spec to_h(type_enumerable()) :: map()
  def to_h(enumerable) do
    if(list_and_not_keyword?(enumerable)) do
      enumerable
      |> Enum.map(&{Enum.at(&1, 0), Enum.at(&1, 1)})
      |> Map.new()
    else
      Map.new(enumerable)
    end
  end

  @doc """
  The function is called with each element.
  The function should return a 2-element tuple which becomes a key-value pair in the returned map.
  ## Examples
      iex> REnum.to_h([[:a, 1], [:b, 2]], fn el ->
      ...>     {REnum.at(el, 0), REnum.at(el, 1)}
      ...>   end)
      %{a: 1, b: 2}

      iex>  REnum.to_h(%{a: 1, b: 2}, fn {key, value} -> {key, value * 2} end)
      %{a: 2, b: 4}
  """
  @spec to_h(type_enumerable(), function()) :: map()
  def to_h(enumerable, func) do
    Map.new(enumerable, func)
  end

  @doc """
  Calls the given function with each element, returns given enumerable:
  ## Examples
      iex> ["a", "b", "c"]
      iex> |> REnum.each_entry(&IO.inspect(&1))
      # "a"
      # "b"
      # "c"
      ["a", "b", "c"]

      iex> %{a: 1, b: 2}
      iex> |> REnum.each_entry(&IO.inspect(&1))
      # {:a, 1}
      # {:b, 2}
      %{a: 1, b: 2}
  """
  @spec each_entry(type_enumerable(), function()) :: type_enumerable()
  def each_entry(enumerable, func) do
    enumerable
    |> Enum.each(func)

    enumerable
  end

  @doc """
  Returns Stream given enumerable sliced by each amount.
  ## Examples
      iex> ["a", "b", "c", "d", "e"]
      iex> |> REnum.each_slice(2)
      iex> |> Enum.to_list()
      [["a", "b"], ["c", "d"], ["e"]]

      iex> %{a: 1, b: 2, c: 3}
      iex> |> REnum.each_slice(2)
      iex> |> Enum.to_list()
      [[a: 1, b: 2], [c: 3]]
  """
  @spec each_slice(type_enumerable(), non_neg_integer()) :: type_enumerable() | atom()
  def each_slice(enumerable, amount) do
    if(amount < 1) do
      []
    else
      enumerable
      |> each_slice(
        0,
        amount
      )
    end
    |> lazy()
  end

  def each_slice(enumerable, start_index, amount_or_func) when is_integer(amount_or_func) do
    sliced =
      enumerable
      |> Enum.slice(start_index, amount_or_func)

    next_start_index = start_index + amount_or_func

    [sliced] ++
      if Enum.count(enumerable) > next_start_index,
        do: each_slice(enumerable, next_start_index, amount_or_func),
        else: []
  end

  @doc """
  Calls the given function with each element, returns given enumerable.
  ## Examples
      iex> ["a", "b", "c", "d", "e"]
      iex> |> REnum.each_slice(2, &IO.inspect(&1))
      # ["a", "b"]
      # ["c", "d"]
      # ["e"]
      :ok

      iex> %{a: 1, b: 2, c: 3}
      iex> |> REnum.each_slice(2, &IO.inspect(&1))
      # [a: 1, b: 2]
      # [c: 3]
      :ok
  """
  @spec each_slice(type_enumerable(), non_neg_integer(), function() | non_neg_integer()) :: atom()
  def each_slice(enumerable, amount, amount_or_func) when is_function(amount_or_func) do
    each_slice(enumerable, amount)
    |> Enum.each(fn els ->
      amount_or_func.(els)
    end)
  end

  @doc """
  Returns Stream, which redefines most Enumerable functions to postpone enumeration and enumerate values only on an as-needed basis.
  ## Examples
      iex> [1, 2, 3]
      iex> |> REnum.lazy()
      iex> |> REnum.to_list()
      [1, 2, 3]
  """
  @spec lazy(type_enumerable()) :: type_enumerable()
  def lazy(enumerable) do
    enumerable
    |> chain([])
    |> Stream.take(Enum.count(enumerable))
  end

  @doc """
  With argument pattern, returns an elements that uses the pattern to partition elements into lists (“slices”).
  An element ends the current slice if element matches pattern.
  With a function, returns an elements that uses the function to partition elements into list.
  An element ends the current slice if its function return is a truthy value.
  ## Examples
      iex> [0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2]
      iex> |> REnum.slice_after(&(rem(&1, 2) == 0))
      [[0], [2], [4], [1, 2], [4], [5, 3, 1, 4], [2]]

      iex> ["a", "b", "c"]
      iex> |> REnum.slice_after(~r/b/)
      [["a", "b"], ["c"]]
  """
  @spec slice_after(type_enumerable(), function() | type_pattern()) :: type_enumerable()
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

  @doc """
  With argument pattern, returns an elements that uses the pattern to partition elements into lists (“slices”).
  An element begins a new slice if element matches pattern. (or if it is the first element).
  With a function, returns an elements that uses the function to partition elements into list.
  An element ends the current slice if its function return is a truthy value.
  ## Examples
      iex> [0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2]
      iex> |> REnum.slice_before(&(rem(&1, 2) == 0))
      [[0], [2], [4, 1], [2], [4, 5, 3, 1], [4], [2]]

      iex> ["a", "b", "c"]
      iex> |> REnum.slice_before(~r/b/)
      [["a"], ["b", "c"]]
  """
  @spec slice_before(type_enumerable(), function() | type_pattern()) :: type_enumerable()
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

  @doc """
  The returned elements uses the function to partition elements into lists (“slices”).
  It calls the function with each element and its successor.
  Begins a new slice if and only if the function returns a truthy value.
  &1 is current_element and &2 is next_element in function arguments.
  ## Examples
      iex> [1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21]
      iex> |> REnum.slice_when(&(&1 + 1 != &2))
      [[1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21]]
  """
  @spec slice_when(type_enumerable(), function() | type_pattern()) :: type_enumerable()
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

  @doc """
  Returns elements selected by a given pattern or function.
  ## Examples
      iex> ["foo", "bar", "car", "moo"]
      iex> |> REnum.grep(~r/ar/)
      ["bar", "car"]

      iex> 1..10
      iex> |> REnum.grep(3..8)
      [3, 4, 5, 6, 7, 8]
  """
  @spec grep(type_enumerable(), function() | type_pattern()) :: type_enumerable()
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

  @doc """
  Calls the function with each matching element and returned.
  ## Examples
      iex> ["foo", "bar", "car", "moo"]
      iex> |> REnum.grep(~r/ar/, &String.upcase(&1))
      ["BAR", "CAR"]

      iex> 1..10
      iex> |> REnum.grep(3..8, &to_string(&1))
      ["3", "4", "5", "6", "7", "8"]
  """
  @spec grep(type_enumerable(), function() | type_pattern(), function()) :: type_enumerable()
  def grep(enumerable, pattern, func) do
    enumerable
    |> grep(pattern)
    |> Enum.map(func)
  end

  @doc """
  Returns elements rejected by a given pattern or function.
  ## Examples
      iex> ["foo", "bar", "car", "moo"]
      iex> |> REnum.grep_v(~r/ar/)
      ["foo", "moo"]

      iex> 1..10
      iex> |> REnum.grep_v(3..8)
      [1, 2, 9, 10]
  """
  @spec grep_v(type_enumerable(), function() | type_pattern()) :: type_enumerable()
  def grep_v(enumerable, pattern) do
    greped = enumerable |> grep(pattern)

    enumerable
    |> Enum.reject(&(&1 in greped))
  end

  @doc """
  Calls the function with each unmatching element and returned.
  ## Examples
      iex> ["foo", "bar", "car", "moo"]
      iex> |> REnum.grep_v(~r/ar/, &String.upcase(&1))
      ["FOO", "MOO"]

      iex> 1..10
      iex> |> REnum.grep_v(3..8, &to_string(&1))
      ["1", "2", "9", "10"]
  """
  @spec grep_v(type_enumerable(), function() | type_pattern(), function()) :: type_enumerable()
  def grep_v(enumerable, pattern, func) do
    enumerable
    |> grep_v(pattern)
    |> Enum.map(func)
  end

  # aliases

  defdelegate detect(enumerable, default, func), to: Enum, as: :find
  defdelegate detect(enumerable, func), to: Enum, as: :find
  defdelegate select(enumerable, func), to: Enum, as: :filter
  defdelegate find_all(enumerable, func), to: Enum, as: :filter
  defdelegate inject(enumerable, acc, func), to: Enum, as: :reduce
  defdelegate inject(enumerable, func), to: Enum, as: :reduce
  defdelegate collect(enumerable, func), to: Enum, as: :map
  defdelegate include?(enumerable, element), to: Enum, as: :member?
  defdelegate collect_concat(enumerable, func), to: Enum, as: :flat_map
  defdelegate entries(enumerable), to: __MODULE__, as: :to_a
  defdelegate each_with_object(enumerable, collectable, func), to: Enum, as: :reduce
  defdelegate each_with_index(enumerable, func), to: Enum, as: :with_index
  defdelegate each_with_index(enumerable), to: Enum, as: :with_index
  defdelegate minmax(enumerable), to: Enum, as: :min_max
  defdelegate minmax(enumerable, func), to: Enum, as: :min_max
  defdelegate minmax_by(enumerable, func), to: Enum, as: :min_max_by
  defdelegate minmax_by(enumerable, func1, func2), to: Enum, as: :min_max_by
  defdelegate minmax_by(enumerable, func1, func2, func3), to: Enum, as: :min_max_by
  defdelegate tally(enumerable), to: Enum, as: :frequencies
  defdelegate chain(enumerables), to: Stream, as: :concat
  defdelegate chain(first, second), to: Stream, as: :concat
  defdelegate to_a(enumerables), to: Enum, as: :to_list
  defdelegate to_l(enumerables), to: Enum, as: :to_list
end
