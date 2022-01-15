defmodule REnum.Enumerable.ActiveSupport do
  import REnum.Utils
  import REnum.Enumerable.Support

  @moduledoc """
  Unimplemented.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()
  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()
  @type type_map_list :: list(struct() | map())

  # https://www.rubydoc.info/gems/activesupport/Enumerable
  # ruby_enumerable = [:as_json, :compact_blank, :exclude?, :excluding, :in_order_of, :including, :index_by, :index_with, :many?, :maximum, :minimum, :pick, :pluck, :sole, :without]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # as_json
  # ✔ compact_blank
  # ✔ exclude?
  # ✔ excluding
  # in_order_of
  # ✔ including
  # ✔ index_by
  # ✔ index_with
  # ✔ many?
  # ✔ maximum
  # ✔ minimum
  # ✔ pick
  # ✔ pluck
  # sole
  # ✔ without

  @spec compact_blank(type_enumerable) :: type_enumerable
  def compact_blank(enumerable) when is_list(enumerable) do
    enumerable
    |> Enum.reject(&(&1 |> blank?()))
  end

  def compact_blank(enumerable) when is_map(enumerable) do
    enumerable
    |> Enum.reject(fn {_, value} ->
      blank?(value)
    end)
    |> Enum.into(%{})
  end

  @spec exclude?(type_enumerable, any()) :: boolean()
  def exclude?(enumerable, element) do
    !Enum.member?(enumerable, element)
  end

  @spec excluding(type_enumerable, type_enumerable) :: type_enumerable
  def excluding(enumerable, elements) do
    cond do
      map_and_not_range?(enumerable) ->
        enumerable
        |> Enum.filter(fn {key, _} ->
          exclude?(elements, key)
        end)
        |> Map.new()

      true ->
        enumerable
        |> Enum.filter(fn el ->
          elements
          |> exclude?(el)
        end)
    end
  end

  @spec including(type_enumerable, type_enumerable) :: list()
  def including(enumerable, elements) do
    (enumerable |> Enum.to_list()) ++ (elements |> Enum.to_list())
  end

  @spec many?(type_enumerable()) :: boolean
  def many?(enumerable) do
    enumerable
    |> Enum.count() > 1
  end

  @spec many?(type_enumerable(), type_pattern() | function()) :: boolean
  def many?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) > 1
  end

  @spec pick(type_map_list(), list(atom()) | atom()) :: any
  def pick([], _keys), do: nil

  def pick(map_list, keys) when is_list(keys) do
    [head | _] = map_list

    if(many?(keys)) do
      keys
      |> Enum.map(fn key ->
        Map.get(head, key)
      end)
    else
      [key | _] = keys
      Map.get(head, key)
    end
  end

  def pick(map_list, key) when is_atom(key) do
    [head | _] = map_list
    Map.get(head, key)
  end

  @spec pluck(type_map_list(), list(atom()) | atom()) :: list(any())
  def pluck(map_list, keys) when is_list(keys) do
    if(many?(keys)) do
      map_list
      |> Enum.map(fn el ->
        keys
        |> Enum.map(fn key ->
          Map.get(el, key)
        end)
      end)
    else
      [key | _] = keys

      map_list
      |> Enum.map(fn el ->
        Map.get(el, key)
      end)
    end
  end

  def pluck(map_list, key) do
    map_list
    |> Enum.map(fn el ->
      Map.get(el, key)
    end)
  end

  @spec maximum(type_map_list(), atom()) :: any
  def maximum(map_list, key) do
    map_list
    |> pluck(key)
    |> Enum.max(fn -> nil end)
  end

  @spec minimum(type_map_list(), atom()) :: any
  def minimum(map_list, key) do
    map_list
    |> pluck(key)
    |> Enum.min(fn -> nil end)
  end

  @spec index_by(type_map_list(), function() | atom()) :: map
  def index_by(enumerable, key) when is_atom(key) do
    enumerable
    |> Enum.reduce(%{}, fn el, acc ->
      acc
      |> Map.put(
        Map.get(el, key),
        el
      )
    end)
  end

  def index_by(enumerable, func) do
    enumerable
    |> Enum.reduce(%{}, fn el, acc ->
      acc
      |> Map.put(func.(el), el)
    end)
  end

  @spec index_with(list(any()), function()) :: map
  def index_with(keys, func) when is_function(func) do
    keys
    |> Enum.map(fn key ->
      {key, func.(key)}
    end)
    |> Map.new()
  end

  def index_with(keys, value) do
    keys
    |> Enum.map(fn key ->
      {key, value}
    end)
    |> Map.new()
  end

  defdelegate without(enumerable, elements), to: __MODULE__, as: :excluding
end
