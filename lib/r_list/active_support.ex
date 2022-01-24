defmodule RList.ActiveSupport do
  @moduledoc """
  Summarized all of List functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use ActiveSupport`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()
  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()

  # https://www.rubydoc.info/gems/activesupport/Array
  # [:as_json, :compact_blank!, :deep_dup, :excluding, :extract!, :extract_options!, :fifth, :forty_two, :fourth, :from, :in_groups, :in_groups_of, :including, :inquiry, :second, :second_to_last, :split, :sum, :third, :third_to_last, :to, :to_default_s, :to_formatted_s, :to_param, :to_query, :to_s, :to_sentence, :to_xml]
  # |> RUtils.required_functions([List, REnum])
  # as_json
  # deep_dup
  # fifth
  # forty_two
  # fourth
  # from
  # in_groups
  # in_groups_of
  # inquiry
  # second
  # second_to_last
  # third
  # third_to_last
  # to
  # to_default_s
  # to_formatted_s
  # to_param
  # to_query
  # to_s
  # to_sentence
  # to_xml
end
