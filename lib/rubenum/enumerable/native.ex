defmodule Rubenum.Enumerable.Native do
  defmacro __using__(_opts) do
    Rubenum.Utils.define_all_functions!(Enum)
  end
end
