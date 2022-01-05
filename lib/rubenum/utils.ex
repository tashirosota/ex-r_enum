defmodule Rubenum.Utils do
  @spec define_all_functions!(module()) :: list
  def define_all_functions!(mod) do
    enum_funs =
      mod.module_info()[:exports]
      |> Enum.filter(fn {fun, _} -> fun not in [:__info__, :module_info] end)

    for {fun, arity} <- enum_funs do
      quote do
        defdelegate unquote(fun)(unquote_splicing(make_args(arity))), to: unquote(mod)
      end
    end
  end

  def make_args(0), do: []

  def make_args(n) do
    Enum.map(1..n, fn n -> {String.to_atom("arg#{n}"), [], Elixir} end)
  end
end
