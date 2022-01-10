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
end
