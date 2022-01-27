defmodule RMap.Support do
  @moduledoc """
  Summarized other useful functions related to Lit.
  Defines all of here functions when `use RMap.Support`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  @doc """
  Returns list recursively converted　 from given map to list.
  ## Examples
      iex> RMap.deep_to_list(%{a: 1, b: %{c: 2, d: {1, 2}, e: [1, 2]}})
      [[:a, 1], [:b, [[:c, 2], [:d, [1, 2]], [:e, [1, 2]]]]]
  """
  @spec deep_to_list(map()) :: list()
  def deep_to_list(map) when is_map(map) do
    map
    |> Enum.map(&deep_to_list(&1))
  end

  def deep_to_list(tuple) when is_tuple(tuple) do
    Tuple.to_list(tuple)
    |> Enum.map(&deep_to_list(&1))
  end

  def deep_to_list(any), do: any
end
