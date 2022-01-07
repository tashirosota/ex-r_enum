defmodule REnum.Enumerable.Native do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Enum)
  end
end
