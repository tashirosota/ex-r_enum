defmodule Rubenum.Utils do
  def make_args(0), do: []

  def make_args(n) do
    Enum.map(1..n, fn n -> {String.to_atom("arg#{n}"), [], Elixir} end)
  end
end
