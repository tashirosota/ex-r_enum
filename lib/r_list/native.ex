defmodule RList.Native do
  @moduledoc """
  A module defines all of native List functions when `use RList.Native`.
  [See also.](https://hexdocs.pm/elixir/List.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(List)
  end
end
