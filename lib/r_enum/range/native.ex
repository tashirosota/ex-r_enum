defmodule REnum.Range.Native do
  @moduledoc """
  A module defines all of native Range functions when `use REnum.Range.Native`.
  [See also.](https://hexdocs.pm/elixir/Range.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Range)
  end
end
