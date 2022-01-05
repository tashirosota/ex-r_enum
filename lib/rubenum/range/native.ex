defmodule Rubenum.Range.Native do
  defmacro __using__(_opts) do
    Rubenum.Utils.define_all_functions!(Range)
  end
end
