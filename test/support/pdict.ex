defmodule Pdict do
  defstruct []

  defimpl Collectable do
    def into(struct) do
      fun = fn
        _, {:cont, x} -> Process.put(:stream_cont, [x | Process.get(:stream_cont)])
        _, :done -> Process.put(:stream_done, true)
        _, :halt -> Process.put(:stream_halt, true)
      end

      {struct, fun}
    end
  end
end
