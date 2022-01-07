defmodule REnum.Enumerable.ActiveSupport do
  defmacro __using__(_opts) do
    REnum.Utils.define_all_functions!(__MODULE__)
  end

  # https://www.rubydoc.info/gems/activesupport/Enumerable
  # ruby_enumerable = [:as_json, :compact_blank, :exclude?, :excluding, :in_order_of, :including, :index_by, :index_with, :many?, :maximum, :minimum, :pick, :pluck, :sole]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # as_json
  # compact_blank
  # exclude?
  # excluding
  # in_order_of
  # including
  # index_by
  # index_with
  # many?
  # maximum
  # minimum
  # pick
  # pluck
  # sole
end
