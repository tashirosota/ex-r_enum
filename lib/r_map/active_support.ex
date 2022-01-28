defmodule RMap.ActiveSupport do
  @moduledoc """
  Summarized all of Hash functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use RMap.ActiveSupport`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  import RMap.Ruby

  # https://www.rubydoc.info/gems/activesupport/Hash
  # [:as_json, :assert_valid_keys, :compact_blank, :compact_blank!, :deep_dup, :deep_merge, :deep_merge!, :deep_stringify_keys, :deep_stringify_keys!, :deep_symbolize_keys, :deep_symbolize_keys!, :deep_transform_keys, :deep_transform_keys!, :deep_transform_values, :deep_transform_values!, :except, :except!, :extract!, :extractable_options?, :reverse_merge, :reverse_merge!, :slice!, :stringify_keys, :stringify_keys!, :symbolize_keys, :symbolize_keys!, :to_query, :to_xml, :with_indifferent_access]
  # |> RUtils.required_functions([List, RMap.Ruby, REnum])
  # × as_json
  # ✔ assert_valid_keys
  # × deep_dup
  # × deep_merge
  # ✔ deep_stringify_keys
  # ✔ deep_symbolize_keys
  # ✔ deep_transform_keys
  # ✔ deep_transform_values
  # × extractable_options?
  # × reverse_merge
  # ✔ stringify_keys
  # ✔ symbolize_keys
  # to_query
  # to_xml
  # with_indifferent_access TODO: Low priority

  @doc """
  Validates all keys in a map match given keys, raising ArgumentError on a mismatch.
  ## Examples
      iex> RMap.assert_valid_keys(%{name: "Rob", years: "28"}, [:name, :age])
      ** (ArgumentError) Unknown key: years. Valid keys are: name, age

      iex> RMap.assert_valid_keys(%{name: "Rob", age: "28"}, ["age"])
      ** (ArgumentError) Unknown key: age. Valid keys are: age

      iex> RMap.assert_valid_keys(%{name: "Rob", age: "28"}, [:name, :age])
      :ok
  """
  @spec assert_valid_keys(map(), list()) :: :ok
  def assert_valid_keys(map, keys) do
    valid_keys_str = keys |> Enum.map(&IO.inspect(&1)) |> Enum.join(", ")

    each_key(map, fn key ->
      if(key not in keys) do
        raise ArgumentError, "Unknown key: #{key}. Valid keys are: #{valid_keys_str}"
      end
    end)
  end

  @doc """
  Returns a map with all keys converted to strings.
  ## Examples
      iex> RMap.stringify_keys(%{name: "Rob", years: "28", nested: %{ a: 1 }})
      %{"name" => "Rob", "nested" => %{a: 1}, "years" => "28"}
  """
  @spec stringify_keys(map()) :: map()
  def stringify_keys(map) do
    transform_keys(map, &to_string(&1))
  end

  @doc """
  Returns a list with all keys converted to strings.
  This includes the keys from the root map and from all nested maps and arrays.
  ## Examples
      iex> RMap.deep_stringify_keys(%{name: "Rob", years: "28", nested: %{ a: 1 }})
      %{"name" => "Rob", "nested" => %{"a" => 1}, "years" => "28"}

      iex> RMap.deep_stringify_keys(%{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}})
      %{"a" => %{"b" => %{"c" => 1}, "d" => [%{"a" => 1, "b" => %{"c" => 2}}]}}
  """
  @spec deep_stringify_keys(map()) :: map()
  def deep_stringify_keys(map) do
    deep_transform_keys(map, &to_string(&1))
  end

  @doc """
  Returns a map with all keys converted to atom.
  ## Examples
      iex> RMap.symbolize_keys(%{"name" => "Rob", "years" => "28", "nested" => %{ "a" => 1 }})
      %{name: "Rob", nested: %{"a" => 1}, years: "28"}
  """
  @spec symbolize_keys(map()) :: map()
  def symbolize_keys(map) do
    transform_keys(map, &String.to_atom(&1))
  end

  @doc """
  Returns a list with all keys converted to atom.
  This includes the keys from the root map and from all nested maps and arrays.
  ## Examples
      iex> RMap.deep_symbolize_keys(%{"name" => "Rob", "years" => "28", "nested" => %{ "a" => 1 }})
      %{name: "Rob", nested: %{a: 1}, years: "28"}

      iex> RMap.deep_symbolize_keys(%{"a" => %{"b" => %{"c" => 1}, "d" => [%{"a" => 1, "b" => %{"c" => 2}}]}})
      %{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}}
  """
  @spec deep_symbolize_keys(map()) :: map()
  def deep_symbolize_keys(map) do
    deep_transform_keys(map, &String.to_atom(&1))
  end

  @doc """
  Returns a map with all keys converted by the function.
  This includes the keys from the root map and from all nested maps and arrays.
  ## Examples
      iex> RMap.deep_transform_keys(%{a: %{b: %{c: 1}}}, &to_string(&1))
      %{"a" => %{"b" => %{"c" => 1}}}

      iex> RMap.deep_transform_keys(%{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}}, &inspect(&1))
      %{":a" => %{":b" => %{":c" => 1}, ":d" => [%{":a" => 1, ":b" => %{":c" => 2}}]}}
  """
  @spec deep_transform_keys(map(), function()) :: map()
  def deep_transform_keys(map, func) do
    map
    |> Enum.map(fn {k, v} ->
      cond do
        is_map(v) -> {func.(k), deep_transform_keys(v, func)}
        is_list(v) -> {func.(k), Enum.map(v, fn el -> deep_transform_keys(el, func) end)}
        true -> {func.(k), v}
      end
    end)
    |> Map.new()
  end

  @doc """
  Returns a map with all values converted by the function.
  This includes the keys from the root map and from all nested maps and arrays.
  ## Examples
      iex> RMap.deep_transform_values(%{a: %{b: %{c: 1}}, d: 2}, &inspect(&1))
      %{a: %{b: %{c: "1"}}, d: "2"}

      iex> RMap.deep_transform_values(%{a: %{b: %{c: 1}, d: [%{a: 1, b: %{c: 2}}]}}, &inspect(&1))
      %{a: %{b: %{c: "1"}, d: [%{a: "1", b: %{c: "2"}}]}}
  """
  @spec deep_transform_values(map(), function()) :: map()
  def deep_transform_values(map, func) do
    Enum.map(map, fn {k, v} ->
      cond do
        is_map(v) -> {k, deep_transform_values(v, func)}
        is_list(v) -> {k, Enum.map(v, fn el -> deep_transform_values(el, func) end)}
        true -> {k, func.(v)}
      end
    end)
    |> Map.new()
  end

  @deprecated "Use atomize_keys/1 instead"
  @deprecated "Use deep_atomize_keys/1 instead"
  defdelegate atomlize_keys(map), to: __MODULE__, as: :symbolize_keys
  defdelegate deep_atomlize_keys(map), to: __MODULE__, as: :deep_symbolize_keys
  defdelegate atomize_keys(map), to: __MODULE__, as: :symbolize_keys
  defdelegate deep_atomize_keys(map), to: __MODULE__, as: :deep_symbolize_keys
end
