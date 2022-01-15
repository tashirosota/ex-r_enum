defmodule REnum.Enumerable.Support do
  @moduledoc """
  Summarized other useful functions related to enumerable.
  Defines all of here functions when `use REnum.Enumerable.Support`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()
  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()

  @doc """
  Returns true if argument is range.
  ## Examples
      iex> REnum.range?([1, 2, 3])
      false

      iex> REnum.range?(2..3)
      true
  """
  @spec range?(type_enumerable) :: boolean()
  def range?(_.._), do: true
  def range?(_), do: false

  @doc """
  Returns true if argument is map and not range.
  ## Examples
      iex> REnum.map_and_not_range?(%{})
      true

      iex> REnum.map_and_not_range?(1..3)
      false
  """
  @spec map_and_not_range?(type_enumerable) :: boolean
  def map_and_not_range?(enumerable) do
    is_map(enumerable) && !range?(enumerable)
  end

  @doc """
  Returns true if argument is list and not keyword list.
  ## Examples
      iex> REnum.list_and_not_keyword?([1, 2, 3])
      true

      iex> REnum.list_and_not_keyword?([a: 1, b: 2])
      false
  """
  @spec list_and_not_keyword?(type_enumerable) :: boolean()
  def list_and_not_keyword?(enumerable) do
    !Keyword.keyword?(enumerable) && is_list(enumerable)
  end

  @doc """
  Returns truthy count.
  ## Examples
      iex> REnum.truthy_count([1, 2, 3])
      3

      iex> REnum.truthy_count([1, nil, false])
      1
  """
  @spec truthy_count(type_enumerable) :: non_neg_integer()
  def truthy_count(enumerable) do
    enumerable
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @doc """
  Returns truthy count that judged　by given function.
  ## Examples
      iex> REnum.truthy_count([1, 2, 3], &(&1 < 3))
      2

      iex> REnum.truthy_count([1, nil, false], &(is_nil(&1)))
      1

      iex> REnum.truthy_count(["bar", "baz", "foo"], ~r/a/)
      2
  """
  @spec truthy_count(type_enumerable, function()) :: non_neg_integer()
  def truthy_count(enumerable, func) when is_function(func) do
    enumerable
    |> Enum.filter(func)
    |> Enum.count()
  end

  def truthy_count(enumerable, pattern) do
    enumerable
    |> truthy_count(match_function(pattern))
  end

  @doc """
  Returns matching function required one argument by given pattern.
  ## Examples
      iex> REnum.match_function(1..3).(2)
      true

      iex> REnum.match_function(~r/a/).("bcd")
      false
  """
  @spec match_function(type_pattern) :: function()
  def match_function(pattern) do
    cond do
      Regex.regex?(pattern) -> &(&1 =~ pattern)
      range?(pattern) -> &(&1 in pattern)
      true -> &(&1 == pattern)
    end
  end

  @doc """
  Returns the first element for which function(with each element index) returns a truthy value.
  ## Examples
      iex> REnum.find_index_with_index(1..3, fn el, index ->
      ...>     IO.inspect(index)
      ...>     el == 2
      ...>     end)
      # 0
      # 1
      1
  """
  @spec find_index_with_index(type_enumerable(), function()) :: neg_integer() | nil
  def find_index_with_index(enumerable, func) do
    enumerable
    |> Enum.to_list()
    |> find_index_with_index(func, 0)
  end

  defp find_index_with_index([], _, _), do: nil

  defp find_index_with_index([head | tail], func, index) do
    if(func.(head, index)) do
      index
    else
      find_index_with_index(tail, func, index + 1)
    end
  end
end
