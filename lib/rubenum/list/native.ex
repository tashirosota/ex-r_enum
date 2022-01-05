defmodule Rubenum.List.Native do
  defmacro __using__(_opts) do
    Rubenum.Utils.define_all_functions!(List)
  end
end
