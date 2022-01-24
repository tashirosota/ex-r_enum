defmodule RMap.Native do
  @moduledoc """
  A module defines all of native Map functions when `use RMap.Native`.
  [See also.](https://hexdocs.pm/elixir/Map.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(Map, [:size, :map])
  end
end
