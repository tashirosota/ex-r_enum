defmodule REnum.Enumerable.Support do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(__MODULE__)
  end

  def range?(_.._), do: true
  def range?(_), do: false

  def is_list_and_not_keyword?(enumerable) do
    !Keyword.keyword?(enumerable) && is_list(enumerable)
  end

  def truthy_count(enumerable) do
    enumerable
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def truthy_count(enumerable, func) when is_function(func) do
    enumerable
    |> Enum.filter(func)
    |> Enum.count()
  end

  def match_function(pattern) do
    cond do
      Regex.regex?(pattern) -> &(&1 =~ pattern)
      range?(pattern) -> &(&1 in pattern)
      true -> &(&1 == pattern)
    end
  end

  def find_index_with_index(enumerable, func) do
    enumerable
    |> Enum.to_list()
    |> find_index_with_index(func, 0)
  end

  def find_index_with_index([], _, _), do: nil

  def find_index_with_index([head | tail], func, index) do
    if(func.(head, index)) do
      index
    else
      find_index_with_index(tail, func, index + 1)
    end
  end
end
