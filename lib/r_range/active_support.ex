defmodule RRange.ActiveSupport do
  @moduledoc """
  Summarized all of List functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use RRange.ActiveSupport`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  # https://www.rubydoc.info/gems/activesupport/Range
  # [:as_json, :overlaps?, :sum]
  # |> RUtils.required_functions([Range, RRange.Ruby, REnum])
  # as_json
  # overlaps?
  def overlaps?(range1, range2) do
    range1
    |> Enum.any?(&(&1 in range2))
  end
end
