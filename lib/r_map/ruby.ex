defmodule RMap.Ruby do
  @moduledoc """
  Summarized all of Ruby's Hash functions.
  Functions corresponding to the following patterns are not implemented
   - When a function with the same name already exists in Elixir.
   - When a method name includes `!`.
   - <, <=, ==, >, >=, [], []=, default_*
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  import RMap.Support

  # https://ruby-doc.org/core-3.1.0/Hash.html
  # [:any?, :assoc, :clear, :compact, :compact!, :compare_by_identity, :compare_by_identity?, :deconstruct_keys, :delete, :delete_if, :dig, :each, :each_key, :each_pair, :each_value, :empty?, :eql?, :except, :fetch, :fetch_values, :filter, :filter!, :flatten, :has_key?, :has_value?, :hash, :include?, :initialize_copy, :inspect, :invert, :keep_if, :key, :key?, :keys, :length, :member?, :merge, :merge!, :rassoc, :rehash, :reject, :reject!, :replace, :select, :select!, :shift, :size, :slice, :store, :to_a, :to_h, :to_hash, :to_proc, :to_s, :transform_keys, :transform_keys!, :transform_values, :transform_values!, :update, :value?, :values, :values_at]
  # |> RUtils.required_functions([Map, REnum])
  # ✔ assoc
  # ✔ clear
  # × compare_by_identity
  # × compare_by_identity?
  # × deconstruct_keys
  # ✔ delete_if
  # ✔ dig
  # ✔ each_key
  # ✔ each_pair
  # ✔ each_value
  # ✔ eql?
  # ✔ except
  # ✔ fetch_values
  # ✔ flatten
  # ✔ has_value?
  # hash TODO: Low priority
  # × initialize_copy
  # ✔ inspect
  # ✔ invert
  # ✔ keep_if
  # ✔ key
  # ✔ key?
  # ✔ length
  # ✔ rassoc
  # × rehash
  # ✔ shift
  # ✔ store
  # ✔ to_hash
  # × to_proc
  # ✔ to_s
  # ✔ transform_keys
  # ✔ transform_values
  # ✔ value?
  # ✔ values_at

  @doc """
  Returns a list whose entries are those for which the function returns a truthy value.
  ## Examples
      iex> RMap.filter(%{a: 1, b: 2, c: 3}, fn {_, v} -> v > 1 end)
      %{b: 2, c: 3}
  """
  @spec filter(map(), function()) :: map()
  def filter(map, func) do
    Enum.filter(map, func)
    |> Map.new()
  end

  @doc """
  Returns a list whose entries are all those from self for which the function returns false or nil.
  ## Examples
      iex> RMap.reject(%{a: 1, b: 2, c: 3}, fn {_, v} -> v > 1 end)
      %{a: 1}
  """
  @spec reject(map(), function()) :: map()
  def reject(map, func) do
    Enum.reject(map, func)
    |> Map.new()
  end

  @doc """
  Returns %{}.
  ## Examples
      iex> RMap.clear(%{a: 1, b: 2, c: 3})
      %{}
  """
  @spec clear(map()) :: %{}
  def clear(_) do
    %{}
  end

  @doc """
  Calls the function with each value; returns :ok.
  ## Examples
      iex> RMap.each_value(%{a: 1, b: 2, c: 3}, &IO.inspect(&1))
      # 1
      # 2
      # 3
      :ok
  """
  @spec each_value(map(), function()) :: :ok
  def each_value(map, func) do
    Enum.each(map, fn {_, value} ->
      func.(value)
    end)
  end

  @doc """
  Calls the function with each key; returns :ok.
  ## Examples
      iex> RMap.each_key(%{a: 1, b: 2, c: 3}, &IO.inspect(&1))
      # :a
      # :b
      # :c
      :ok
  """
  @spec each_key(map(), function()) :: :ok
  def each_key(map, func) do
    Enum.each(map, fn {key, _} ->
      func.(key)
    end)
  end

  @doc """
  Returns true if value is a value in list, otherwise false.
  ## Examples
      iex> RMap.value?(%{a: 1, b: 2, c: 3}, 3)
      true

      iex> RMap.value?(%{a: 1, b: 2, c: 3}, 4)
      false
  """
  @spec value?(map(), any) :: boolean()
  def value?(map, value) do
    Enum.any?(map, fn {_, v} ->
      v == value
    end)
  end

  @doc """
  Returns a list containing values for the given keys.
  ## Examples
      iex> RMap.values_at(%{a: 1, b: 2, c: 3}, [:a, :b, :d])
      [1, 2, nil]
  """
  @spec values_at(map(), list()) :: list()
  def values_at(map, keys) do
    Enum.map(keys, &Map.get(map, &1))
  end

  @doc """
  Returns given map.
  ## Examples
      iex> RMap.to_hash(%{a: 1, b: 2, c: 3})
      %{a: 1, b: 2, c: 3}
  """
  @spec to_hash(map()) :: map()
  def to_hash(map) do
    map
  end

  @doc """
  Returns the object in nested map that is specified by a given key and additional arguments.
  ## Examples
      iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :b, :c])
      1

      iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :c, :b])
      nil
  """
  def dig(nil, _), do: nil
  def dig(result, []), do: result
  @spec dig(map(), list()) :: any()
  def dig(map, keys) do
    [key | tail_keys] = keys
    result = Map.get(map, key)
    dig(result, tail_keys)
  end

  @doc """
  Returns a 2-element tuple containing a given key and its value.
  ## Examples
      iex> RMap.assoc(%{a: 1, b: 2, c: 3}, :a)
      {:a, 1}

      iex> RMap.assoc(%{a: 1, b: 2, c: 3}, :d)
      nil

      iex> RMap.assoc(%{a: %{b: %{c: 1}}}, :a)
      {:a, %{b: %{c: 1}}}
  """
  @spec assoc(map(), any()) :: any()
  def assoc(map, key) do
    if(value = Map.get(map, key)) do
      {key, value}
    else
      nil
    end
  end

  @doc """
  Returns a 2-element tuple consisting of the key and value of the first-found entry having a given value.
  ## Examples
      iex> RMap.rassoc(%{a: 1, b: 2, c: 3}, 1)
      {:a, 1}

      iex> RMap.rassoc(%{a: 1, b: 2, c: 3}, 4)
      nil

      iex> RMap.rassoc(%{a: %{b: %{c: 1}}}, %{b: %{c: 1}})
      {:a, %{b: %{c: 1}}}
  """
  @spec rassoc(map(), any()) :: any()
  def rassoc(map, value) do
    Enum.find_value(map, fn {k, v} ->
      if v == value, do: {k, v}
    end)
  end

  @doc """
  Returns a map with modified keys.
  ## Examples
      iex> RMap.transform_keys(%{a: 1, b: 2, c: 3}, &to_string(&1))
      %{"a" => 1, "b" => 2, "c" => 3}

      iex> RMap.transform_keys(%{a: %{b: %{c: 1}}}, &to_string(&1))
      %{"a" => %{b: %{c: 1}}}
  """
  @spec transform_keys(map(), function()) :: map()
  def transform_keys(map, func) do
    Enum.map(map, fn {key, value} ->
      {func.(key), value}
    end)
    |> Map.new()
  end

  @doc """
  Returns a map with modified values.
  ## Examples
      iex> RMap.transform_values(%{a: 1, b: 2, c: 3}, &inspect(&1))
      %{a: "1", b: "2", c: "3"}

      iex> RMap.transform_values(%{a: %{b: %{c: 1}}}, &inspect(&1))
      %{a: "%{b: %{c: 1}}"}
  """
  @spec transform_values(map(), function()) :: map()
  def transform_values(map, func) do
    Enum.map(map, fn {key, value} ->
      {key, func.(value)}
    end)
    |> Map.new()
  end

  @doc """
  Returns a map excluding entries for the given keys.
  ## Examples
      iex> RMap.except(%{a: 1, b: 2, c: 3}, [:a, :b])
      %{c: 3}
  """
  @spec except(map(), list()) :: map()
  def except(map, keys) do
    delete_if(map, fn {key, _} ->
      key in keys
    end)
  end

  @doc """
  Returns a list containing the values associated with the given keys.
  ## Examples
      iex> RMap.fetch_values(%{ "cat" => "feline", "dog" => "canine", "cow" => "bovine" }, ["cow", "cat"])
      ["bovine", "feline"]

      iex> RMap.fetch_values(%{ "cat" => "feline", "dog" => "canine", "cow" => "bovine" }, ["cow", "bird"])
      ** (MapKeyError) key not found: bird
  """
  @spec fetch_values(map(), list()) :: list()
  def fetch_values(map, keys) do
    Enum.map(keys, fn key ->
      if(value = map |> Map.get(key)) do
        value
      else
        raise MapKeyError, "key not found: #{key}"
      end
    end)
  end

  @doc """
  When a function is given, calls the function with each missing key, treating the block's return value as the value for that key.
  ## Examples
      iex> RMap.fetch_values(%{ "cat" => "feline", "dog" => "canine", "cow" => "bovine" }, ["cow", "bird"], &(String.upcase(&1)))
      ["bovine", "BIRD"]
  """
  @spec fetch_values(map(), list(), function()) :: list()
  def fetch_values(map, keys, func) do
    Enum.map(keys, fn key ->
      if(value = map |> Map.get(key)) do
        value
      else
        func.(key)
      end
    end)
  end

  @doc """
  Returns a flatten list.
  ## Examples
      iex> RMap.flatten(%{1=> "one", 2 => [2,"two"], 3 => "three"})
      [1, "one", 2, 2, "two", 3, "three"]

      iex> RMap.flatten(%{1 => "one", 2 => %{a: 1, b: %{c: 3}}})
      [1, "one", 2, :a, 1, :b, :c, 3]
  """
  @spec flatten(map()) :: list()
  def flatten(map) do
    deep_to_list(map) |> List.flatten()
  end

  @doc """
  Returns a map object with the each key-value pair inverted.
  ## Examples
      iex> RMap.invert(%{"a" => 0, "b" => 100, "c" => 200, "d" => 300, "e" => 300})
      %{0 => "a", 100 => "b", 200 => "c", 300 => "e"}

      iex> RMap.invert(%{a: 1, b: 1, c: %{d: 2}})
      %{1 => :b, %{d: 2} => :c}
  """
  @spec invert(map()) :: map()
  def invert(map) do
    map
    |> Enum.map(fn {k, v} ->
      {v, k}
    end)
    |> Map.new()
  end

  @doc """
  Removes the first map entry; returns a 2-element tuple.
  First element is {key, value}.
  Second element is a map without first pair.
  ## Examples
      iex> RMap.shift(%{a: 1, b: 2, c: 3})
      {{:a, 1}, %{b: 2, c: 3}}

      iex> RMap.shift(%{})
      {nil, %{}}
  """
  @spec shift(map()) :: {tuple() | nil, map()}
  def shift(map) do
    {result, list} = map |> Enum.split(1)
    {List.last(result), Map.new(list)}
  end

  defdelegate delete_if(map, func), to: __MODULE__, as: :reject
  defdelegate keep_if(map, func), to: __MODULE__, as: :filter
  defdelegate select(map, func), to: __MODULE__, as: :filter
  defdelegate length(map), to: Enum, as: :count
  defdelegate size(map), to: Enum, as: :count
  defdelegate to_s(map), to: Kernel, as: :inspect
  defdelegate inspect(map), to: Kernel, as: :inspect
  defdelegate each_pair(map, func), to: Enum, as: :each
  defdelegate key(map, key, default \\ nil), to: Map, as: :get
  defdelegate key?(map, key), to: Map, as: :has_key?
  defdelegate has_value?(map, value), to: __MODULE__, as: :value?
  defdelegate store(map, key, value), to: Map, as: :put
  defdelegate eql?(map1, map2), to: Map, as: :equal?
end

defmodule MapKeyError do
  defexception [:message]
end
