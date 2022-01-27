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

  # https://ruby-doc.org/core-3.1.0/Hash.html
  # [:any?, :assoc, :clear, :compact, :compact!, :compare_by_identity, :compare_by_identity?, :deconstruct_keys, :delete, :delete_if, :dig, :each, :each_key, :each_pair, :each_value, :empty?, :eql?, :except, :fetch, :fetch_values, :filter, :filter!, :flatten, :has_key?, :has_value?, :hash, :include?, :initialize_copy, :inspect, :invert, :keep_if, :key, :key?, :keys, :length, :member?, :merge, :merge!, :rassoc, :rehash, :reject, :reject!, :replace, :select, :select!, :shift, :size, :slice, :store, :to_a, :to_h, :to_hash, :to_proc, :to_s, :transform_keys, :transform_keys!, :transform_values, :transform_values!, :update, :value?, :values, :values_at]
  # |> RUtils.required_functions([Map, REnum])
  # ✔ assoc
  # ✔ clear
  # compare_by_identity
  # compare_by_identity?
  # deconstruct_keys
  # ✔ delete_if
  # ✔ dig
  # ✔ each_key
  # ✔ each_pair
  # ✔ each_value
  # ✔ eql?
  # except
  # fetch_values
  # flatten
  # ✔ has_value?
  # hash TODO: Low priority
  # initialize_copy
  # ✔ inspect
  # invert
  # ✔ keep_if
  # ✔ key
  # ✔ key?
  # ✔ length
  # ✔ rassoc
  # rehash
  # shift
  # store
  # ✔ to_hash
  # × to_proc
  # ✔ to_s
  # transform_keys
  # transform_values
  # ✔ value?
  # ✔ values_at

  @doc """
  ## Examples
      iex> RMap.filter(%{a: 1, b: 2, c: 3}, fn {_, v} -> v > 1 end)
      %{b: 2, c: 3}
  """
  def filter(map, func) do
    Enum.filter(map, func)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.reject(%{a: 1, b: 2, c: 3}, fn {_, v} -> v > 1 end)
      %{a: 1}
  """
  def reject(map, func) do
    Enum.reject(map, func)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.clear(%{a: 1, b: 2, c: 3})
      %{}
  """
  def clear(_) do
    %{}
  end

  @doc """
  ## Examples
      iex> RMap.each_value(%{a: 1, b: 2, c: 3}, &IO.inspect(&1))
      # 1
      # 2
      # 3
      :ok
  """
  def each_value(map, func) do
    Enum.each(map, fn {_, value} ->
      func.(value)
    end)
  end

  @doc """
  ## Examples
      iex> RMap.each_key(%{a: 1, b: 2, c: 3}, &IO.inspect(&1))
      # :a
      # :b
      # :c
      :ok
  """
  def each_key(map, func) do
    Enum.each(map, fn {key, _} ->
      func.(key)
    end)
  end

  @doc """
  ## Examples
      iex> RMap.eql?(%{a: 1, b: 2, c: 3}, %{a: 1, b: 2, c: 3})
      true

      iex> RMap.eql?(%{a: 1, b: 2, c: 3}, %{a: 1, b: 2, c: 4})
      false
  """
  def eql?(map1, map2) do
    map1 == map2
  end

  @doc """
  ## Examples
      iex> RMap.value?(%{a: 1, b: 2, c: 3}, 3)
      true

      iex> RMap.value?(%{a: 1, b: 2, c: 3}, 4)
      false
  """
  def value?(map, value) do
    Enum.any?(map, fn {_, v} ->
      v == value
    end)
  end

  @doc """
  ## Examples
      iex> RMap.values_at(%{a: 1, b: 2, c: 3}, [:a, :b, :d])
      [1, 2, nil]
  """
  def values_at(map, keys) do
    Enum.map(keys, &Map.get(map, &1))
  end

  @doc """
  ## Examples
      iex> RMap.to_hash(%{a: 1, b: 2, c: 3})
      %{a: 1, b: 2, c: 3}
  """
  def to_hash(map) do
    map
  end

  @doc """
  ## Examples
      iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :b, :c])
      1

      iex> RMap.dig(%{a: %{b: %{c: 1}}}, [:a, :c, :b])
      nil
  """
  def dig(nil, _), do: nil
  def dig(result, []), do: result

  def dig(map, keys) do
    [key | tail_keys] = keys
    result = Map.get(map, key)
    dig(result, tail_keys)
  end

  @doc """
  ## Examples
      iex> RMap.assoc(%{a: 1, b: 2, c: 3}, :a)
      {:a, 1}

      iex> RMap.assoc(%{a: 1, b: 2, c: 3}, :d)
      nil

      iex> RMap.assoc(%{a: %{b: %{c: 1}}}, :a)
      {:a, %{b: %{c: 1}}}
  """
  def assoc(map, key) do
    if(value = Map.get(map, key)) do
      {key, value}
    else
      nil
    end
  end

  @doc """
  ## Examples
      iex> RMap.rassoc(%{a: 1, b: 2, c: 3}, 1)
      {:a, 1}

      iex> RMap.rassoc(%{a: 1, b: 2, c: 3}, 4)
      nil

      iex> RMap.rassoc(%{a: %{b: %{c: 1}}}, %{b: %{c: 1}})
      {:a, %{b: %{c: 1}}}
  """
  def rassoc(map, value) do
    Enum.find_value(map, fn {k, v} ->
      if v == value, do: {k, v}
    end)
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
end
