defmodule REnum.Utils do
  @moduledoc """
  Utils for REnum.
  """
  @doc """
  Defines in the module that called all the functions of the argument module.
  """
  @spec define_all_functions!(module()) :: list
  def define_all_functions!(mod) do
    enum_funs =
      mod.module_info()[:exports]
      |> Enum.filter(fn {fun, _} -> fun not in [:__info__, :module_info, :"MACRO-__using__"] end)

    for {fun, arity} <- enum_funs do
      quote do
        defdelegate unquote(fun)(unquote_splicing(make_args(arity))), to: unquote(mod)
      end
    end
  end

  @doc """
  Creates tuple for `unquote_splicing`.
  """
  @spec make_args(integer) :: list
  def make_args(0), do: []

  def make_args(n) do
    Enum.map(1..n, fn n -> {String.to_atom("arg#{n}"), [], Elixir} end)
  end
end
