defmodule REnum.Enumerable.ActiveSupport do
  import REnum.Utils
  import REnum.Enumerable.Support
  import REnum.Enumerable.Ruby

  @moduledoc """
  Summarized all of Enumerable functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use REnum.Enumerable.Utils`.
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
  # ✔ in_order_of
  # ✔ including
  # ✔ index_by
  # ✔ index_with
  # ✔ many?
  # ✔ maximum
  # ✔ minimum
  # ✔ pick
  # ✔ pluck
  # ✔ sole
  # ✔ without

  @doc """
  Returns a new enumerable without the blank items.
  Uses `REnum.Utils.blank?` for determining if an item is blank.
  ## Examples
      iex> [1, "", nil, 2, " ", [], %{}, false, true]
      ...> |> REnum.compact_blank()
      [1, 2, true]

      iex> %{a: "", b: 1, c: nil, d: [], e: false, f: true}
      ...> |> REnum.compact_blank()
      %{
        b: 1,
        f: true
      }
  """
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

  @doc """
  The negative of the `Enum.member?`.
  Returns +true+ if the collection does not include the object.
  ## Examples
      iex> REnum.exclude?([2], 1)
      true

      iex> REnum.exclude?([2], 2)
      false
  """
  @spec exclude?(type_enumerable, any()) :: boolean()
  def exclude?(enumerable, element) do
    !Enum.member?(enumerable, element)
  end

  @doc """
  Returns enumerable excluded the specified elements.
  ## Examples
      iex> REnum.excluding(1..5, [1, 5])
      [2, 3, 4]

      iex> REnum.excluding(%{foo: 1, bar: 2, baz: 3}, [:bar])
      %{foo: 1, baz: 3}
  """
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

  @doc """
  Returns enumerable included the specified elements.
  ## Examples
      iex> REnum.including([1, 2, 3], [4, 5])
      [1, 2, 3, 4, 5]

      iex> REnum.including(1..3, 4..6)
      [1, 2, 3, 4, 5, 6]

      iex> REnum.including(%{foo: 1, bar: 2, baz: 3}, %{hoge: 4, page: 5})
      [
        {:bar, 2},
        {:baz, 3},
        {:foo, 1},
        {:hoge, 4},
        {:page, 5}
      ]
  """
  @spec including(type_enumerable, type_enumerable) :: list()
  def including(enumerable, elements) do
    (enumerable |> Enum.to_list()) ++ (elements |> Enum.to_list())
  end

  @doc """
  Returns true if the enumerable has more than 1 element.
  ## Examples
      iex>  REnum.many?([])
      false

      iex> REnum.many?([1])
      false

      iex> REnum.many?([1, 2])
      true

      iex>  REnum.many?(%{})
      false

      iex> REnum.many?(%{a: 1})
      false

      iex> REnum.many?(%{a: 1, b: 2})
      true
  """
  @spec many?(type_enumerable()) :: boolean
  def many?(enumerable) do
    enumerable
    |> Enum.count() > 1
  end

  @spec many?(type_enumerable(), type_pattern() | function()) :: boolean
  def many?(enumerable, pattern_or_func) do
    truthy_count(enumerable, pattern_or_func) > 1
  end

  @doc """
  Extract the given key from the first element in the enumerable.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.pick(payments, [:dollars, :cents])
      [5, 99]
      iex> REnum.pick(payments, :dollars)
      5
      iex> REnum.pick([], :dollars)
      nil
  """
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

  @doc """
  Extract the given key from each element in the enumerable.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.pluck(payments, [:dollars, :cents])
      [[5, 99], [10, 0], [0, 5]]
      iex> REnum.pluck(payments, :dollars)
      [5, 10, 0]
      iex> REnum.pluck([], :dollars)
      []
  """
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

  @doc """
  Calculates the maximum from the extracted elements.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.maximum(payments, :cents)
      99
      iex> REnum.maximum(payments, :dollars)
      10
      iex> REnum.maximum([], :dollars)
      nil
  """
  @spec maximum(type_map_list(), atom()) :: any
  def maximum(map_list, key) do
    map_list
    |> pluck(key)
    |> Enum.max(fn -> nil end)
  end

  @doc """
  Calculates the minimum from the extracted elements.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.minimum(payments, :cents)
      0
      iex> REnum.minimum(payments, :dollars)
      0
      iex> REnum.minimum([], :dollars)
      nil
  """
  @spec minimum(type_map_list(), atom()) :: any
  def minimum(map_list, key) do
    map_list
    |> pluck(key)
    |> Enum.min(fn -> nil end)
  end

  @doc """
  Converts an enumerable to a mao, using the function result or key as the key and the element as the value.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.index_by(payments, fn el -> el.cents end)
      %{
        0 => %Payment{cents: 0, dollars: 10},
        5 => %Payment{cents: 5, dollars: 0},
        99 => %Payment{cents: 99, dollars: 5}
      }
      iex> REnum.index_by(payments, :cents)
      %{
        0 => %Payment{cents: 0, dollars: 10},
        5 => %Payment{cents: 5, dollars: 0},
        99 => %Payment{cents: 99, dollars: 5}
      }

  """
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

  @doc """
  Convert an enumerable to a map, using the element as the key and the function result or given value as the value.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.index_with(payments, fn el -> el.cents end)
      %{
        %Payment{cents: 0, dollars: 10} => 0,
        %Payment{cents: 5, dollars: 0} => 5,
        %Payment{cents: 99, dollars: 5} => 99
      }

      iex> REnum.index_with(~w(a, b, c), 3)
      %{"a," => 3, "b," => 3, "c" => 3}

  """
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

  @doc """
  Returns a list where the order has been set to that provided in the series, based on the key of the elements in the original enumerable.
  ## Examples
      iex> payments = [
      ...>   %Payment{dollars: 5, cents: 99},
      ...>   %Payment{dollars: 10, cents: 0},
      ...>   %Payment{dollars: 0, cents: 5}
      ...> ]
      iex> REnum.in_order_of(payments, :cents, [0, 5])
      [
        %Payment{cents: 0, dollars: 10},
        %Payment{cents: 5, dollars: 0}
      ]
  """
  @spec in_order_of(type_map_list(), atom(), list()) :: list()
  def in_order_of(enumerable, key, series) do
    map = enumerable |> index_by(key)

    series
    |> Enum.map(fn s ->
      map[s]
    end)
    |> compact()
  end

  @doc """
  Returns the sole item in the enumerable. If there are no items, or more than one item, raises SoleItemExpectedError.
  ## Examples
      iex> REnum.sole([1])
      1

      iex> REnum.sole([])
      ** (SoleItemExpectedError) no item found
  """
  @spec sole(type_enumerable()) :: boolean()
  def sole(enumerable) do
    case Enum.count(enumerable) do
      1 -> first(enumerable)
      0 -> raise SoleItemExpectedError, "no item found"
      _ -> raise SoleItemExpectedError, "multiple items found"
    end
  end

  defdelegate without(enumerable, elements), to: __MODULE__, as: :excluding
end

defmodule SoleItemExpectedError do
  defexception [:message]
end
