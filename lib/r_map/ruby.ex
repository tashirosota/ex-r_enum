defmodule RMap.Ruby do
  @moduledoc """
  Summarized all of Ruby's Hash functions.
  Functions corresponding to the following patterns are not implemented
   - When a function with the same name already exists in Elixir.
   - When a method name includes `!`.
   - <, <=, ==, >, >=, [], []=, default_*
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  # https://ruby-doc.org/core-3.1.0/Hash.html
  # [:any?, :assoc, :clear, :compact, :compact!, :compare_by_identity, :compare_by_identity?, :deconstruct_keys, :delete, :delete_if, :dig, :each, :each_key, :each_pair, :each_value, :empty?, :eql?, :except, :fetch, :fetch_values, :filter, :filter!, :flatten, :has_key?, :has_value?, :hash, :include?, :initialize_copy, :inspect, :invert, :keep_if, :key, :key?, :keys, :length, :member?, :merge, :merge!, :rassoc, :rehash, :reject, :reject!, :replace, :select, :select!, :shift, :size, :slice, :store, :to_a, :to_h, :to_hash, :to_proc, :to_s, :transform_keys, :transform_keys!, :transform_values, :transform_values!, :update, :value?, :values, :values_at]
  # |> RUtils.required_functions([Map, REnum])
  # assoc
  # clear
  # compare_by_identity
  # compare_by_identity?
  # deconstruct_keys
  # ✔ delete_if
  # dig
  # each_key
  # each_pair
  # each_value
  # eql?
  # except
  # fetch_values
  # flatten
  # has_value?
  # hash TODO: Low priority
  # initialize_copy
  # ✔ inspect
  # invert
  # ✔ keep_if
  # key
  # key?
  # ✔ length
  # rassoc
  # rehash
  # shift
  # store
  # to_hash
  # to_proc
  # ✔ to_s
  # transform_keys
  # transform_values
  # value?
  # values_at

  def fillter(map, func) do
    Enum.filter(map, func)
    |> Map.new()
  end

  def reject(map, func) do
    Enum.reject(map, func)
    |> Map.new()
  end

  defdelegate delete_if(map, func), to: __MODULE__, as: :reject
  defdelegate keep_if(map, func), to: __MODULE__, as: :filter
  defdelegate select(map, func), to: __MODULE__, as: :filter
  defdelegate length(map), to: Enum, as: :count
  defdelegate to_s(list), to: Kernel, as: :inspect
  defdelegate inspect(list), to: Kernel, as: :inspect
end
