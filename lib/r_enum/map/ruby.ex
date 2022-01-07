defmodule REnum.Map.Ruby do
  defmacro __using__(_opts) do
    #   enum_funs = Enum.module_info()[:exports]
    #            |> Enum.filter(fn {fun, _} -> fun not in [:__info__, :module_info] end)

    #   for {fun, arity} <- enum_funs do
    #     quote do
    #       defdelegate unquote(fun)(unquote_splicing(REnum.Utils.make_args(arity))), to: REnum.Map.Ruby
    #     end
    #   end
  end

  # TODO:
end
