defmodule REnum.Enumerable.Native do
  # @deprecate_functions [:partition, :filter_map, :chunk, :uniq]
  @deprecate_functions []
  @moduledoc """
  A module defines all of native Enum functions when `use REnum.Enumerable.Native`.
  [See also.](https://hexdocs.pm/elixir/Enum.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Enum, @deprecate_functions)
  end
end
