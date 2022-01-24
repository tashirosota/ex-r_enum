defmodule RStream.Native do
  @deprecate_functions [:filter_map, :chunk, :uniq]
  @moduledoc """
  A module defines all of native Stream functions when `use RStream.Native`.
  [See also.](https://hexdocs.pm/elixir/Stream.html)
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(Stream, @deprecate_functions)
  end
end
