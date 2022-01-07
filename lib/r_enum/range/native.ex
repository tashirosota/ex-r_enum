defmodule REnum.Range.Native do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Range)
  end
end
