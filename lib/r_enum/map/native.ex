defmodule REnum.Map.Native do
  @moduledoc """
  A module defines all of native Map functions when `use REnum.Map.Native`.
  [See also.](https://hexdocs.pm/elixir/Map.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Map)
  end
end
