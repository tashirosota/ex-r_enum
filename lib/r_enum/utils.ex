defmodule REnum.Utils do
  @brank_regex ~r/\A[[:space:]]*\z/
  @default_undelegate_functions [:__info__, :module_info, :"MACRO-__using__"]
  @moduledoc """
  Utils for REnum.
  """
  @doc """
  Defines in the module that called all the functions of the argument module.
  """
  @spec define_all_functions!(module()) :: list
  def define_all_functions!(mod, undelegate_functions \\ []) do
    enum_funs =
      mod.module_info()[:exports]
      |> Enum.filter(fn {fun, _} ->
        fun not in (@default_undelegate_functions ++ undelegate_functions)
      end)

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

  def blank?(map) when map == %{}, do: true
  def blank?([]), do: true
  def blank?(nil), do: true
  def blank?(false), do: true

  def blank?(str) when is_bitstring(str) do
    str
    |> String.match?(@brank_regex)
  end

  def blank?(_), do: false

  def present?(obj) do
    !blank?(obj)
  end
end
