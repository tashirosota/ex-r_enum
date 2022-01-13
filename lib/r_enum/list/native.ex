defmodule REnum.List.Native do
  @moduledoc """
  A module defines all of native List functions when `use REnum.List.Native`.
  [See also.](https://hexdocs.pm/elixir/List.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(List)
  end
end
