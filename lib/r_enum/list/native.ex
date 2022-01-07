defmodule REnum.List.Native do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(List)
  end
end
