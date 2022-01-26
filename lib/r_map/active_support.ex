defmodule RMap.ActiveSupport do
  @moduledoc """
  Summarized all of Hash functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use RMap.ActiveSupport`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  # https://www.rubydoc.info/gems/activesupport/Hash
  # [:as_json, :assert_valid_keys, :compact_blank, :compact_blank!, :deep_dup, :deep_merge, :deep_merge!, :deep_stringify_keys, :deep_stringify_keys!, :deep_symbolize_keys, :deep_symbolize_keys!, :deep_transform_keys, :deep_transform_keys!, :deep_transform_values, :deep_transform_values!, :except, :except!, :extract!, :extractable_options?, :reverse_merge, :reverse_merge!, :slice!, :stringify_keys, :stringify_keys!, :symbolize_keys, :symbolize_keys!, :to_query, :to_xml, :with_indifferent_access]
  # |> RUtils.required_functions([List, RMap.Ruby, REnum])
  # as_json
  # assert_valid_keys
  # deep_dup
  # deep_merge
  # deep_stringify_keys
  # deep_symbolize_keys
  # deep_transform_keys
  # deep_transform_values
  # except
  # extractable_options?
  # reverse_merge
  # stringify_keys
  # symbolize_keys
  # to_query
  # to_xml
  # with_indifferent_access
end
