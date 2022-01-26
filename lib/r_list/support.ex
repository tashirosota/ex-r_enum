defmodule RList.Support do
  @moduledoc """
  Summarized other useful functions related to Lit.
  Defines all of here functions when `use RList.Support`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()

  @spec new(any) :: [...]
  @doc """
  Equal to `[el]`.
  ## Examples
      iex> 1
      iex> |> RList.new()
      [1]
  """
  def new(el) do
    [el]
  end

  @doc """
  Make a list of size amount.
  ## Examples
      iex> 1
      iex> |> RList.new(3)
      [1, 1, 1]
  """
  def new(el, amount) do
    1..amount
    |> Enum.map(fn _ ->
      el
    end)
  end
end
