defmodule Rubenum.Map.Native do
  defmacro __using__(_opts) do
    Rubenum.Utils.define_all_functions!(Map)
  end
end
