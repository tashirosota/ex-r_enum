defmodule REnum.Stream.Native do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(Stream)
  end
end
