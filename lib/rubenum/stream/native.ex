defmodule Rubenum.Stream.Native do
  defmacro __using__(_opts) do
    Rubenum.Utils.define_all_functions!(Stream)
  end
end
