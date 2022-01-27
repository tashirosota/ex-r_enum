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
  # extractable_options?
  # reverse_merge
  # ✔ stringify_keys
  # ✔ symbolize_keys
  # to_query
  # to_xml
  # with_indifferent_access

  @doc """
  ## Examples
      iex> RMap.assert_valid_keys(%{name: "Rob", years: "28"}, [:name, :age])
      ** (ArgumentError) Unknown key: years. Valid keys are: name, age

      iex> RMap.assert_valid_keys(%{name: "Rob", age: "28"}, ["age"])
      ** (ArgumentError) Unknown key: age. Valid keys are: age

      iex> RMap.assert_valid_keys(%{name: "Rob", age: "28"}, [:name, :age])
      :ok
  """
  def assert_valid_keys(map, keys) do
    valid_keys_str = keys |> Enum.map(&IO.inspect(&1)) |> Enum.join(", ")

    each_key(map, fn key ->
      if(key not in keys) do
        raise ArgumentError, "Unknown key: #{key}. Valid keys are: #{valid_keys_str}"
      end
    end)
  end

  @doc """
  ## Examples
      iex> RMap.stringify_keys(%{name: "Rob", years: "28", nested: %{ a: 1 }})
      %{"name" => "Rob", "nested" => %{a: 1}, "years" => "28"}
  """
  def stringify_keys(map) do
    map
    |> Enum.map(fn {k, v} ->
      {to_string(k), v}
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.deep_stringify_keys(%{name: "Rob", years: "28", nested: %{ a: 1 }})
      %{"name" => "Rob", "nested" => %{"a" => 1}, "years" => "28"}
  """
  def deep_stringify_keys(map) do
    map
    |> Enum.map(fn {k, v} ->
      if is_map(v), do: {to_string(k), deep_stringify_keys(v)}, else: {to_string(k), v}
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.symbolize_keys(%{"name" => "Rob", "years" => "28", "nested" => %{ "a" => 1 }})
      %{name: "Rob", nested: %{"a" => 1}, years: "28"}
  """
  def symbolize_keys(map) do
    map
    |> Enum.map(fn {k, v} ->
      {String.to_atom(k), v}
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.deep_symbolize_keys(%{"name" => "Rob", "years" => "28", "nested" => %{ "a" => 1 }})
      %{name: "Rob", nested: %{a: 1}, years: "28"}
  """
  def deep_symbolize_keys(map) do
    map
    |> Enum.map(fn {k, v} ->
      if is_map(v), do: {String.to_atom(k), deep_symbolize_keys(v)}, else: {String.to_atom(k), v}
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.deep_transform_keys(%{a: %{b: %{c: 1}}}, &to_string(&1))
      %{"a" => %{"b" => %{"c" => 1}}}
  """
  def deep_transform_keys(map, func) do
    map
    |> Enum.map(fn {k, v} ->
      if is_map(v), do: {func.(k), deep_transform_keys(v, func)}, else: {func.(k), v}
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> RMap.deep_transform_values(%{a: %{b: %{c: 1}}, d: 2}, &inspect(&1))
       %{a: %{b: %{c: "1"}}, d: "2"}
  """
  def deep_transform_values(map, func) do
    Enum.map(map, fn {k, v} ->
      if is_map(v), do: {k, deep_transform_values(v, func)}, else: {k, func.(v)}
    end)
    |> Map.new()
  end

  defdelegate atomlize_keys(map), to: __MODULE__, as: :symbolize_keys
  defdelegate deep_atomlize_keys(map), to: __MODULE__, as: :deep_symbolize_keys
end
