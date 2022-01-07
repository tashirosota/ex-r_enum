defmodule REnum.Map.Native do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Map)
  end
end
