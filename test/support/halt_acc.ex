# TODO: moves test dir
defmodule HaltAcc do
  defstruct [:acc]

  defimpl Enumerable do
    def count(_lazy), do: {:error, __MODULE__}

    def member?(_lazy, _value), do: {:error, __MODULE__}

    def slice(_lazy), do: {:error, __MODULE__}

    def reduce(lazy, _acc, _fun) do
      {:halted, Enum.to_list(lazy.acc)}
    end
  end
end
