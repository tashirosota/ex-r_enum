defmodule Rubenum.Enumerable.Ruby do
  defmacro __using__(_opts) do
    #   enum_funs = Enum.module_info()[:exports]
    #            |> Enum.filter(fn {fun, _} -> fun not in [:__info__, :module_info] end)

    #   for {fun, arity} <- enum_funs do
    #     quote do
    #       defdelegate unquote(fun)(unquote_splicing(Rubenum.Utils.make_args(arity))), to: Rubenum.Enumerable.Ruby
    #     end
    #   end
  end

  # ruby_enumerable = [:all?, :any?, :chain, :chunk, :chunk_while, :collect, :collect_concat, :compact, :count, :cycle, :detect, :drop, :drop_while, :each_cons, :each_entry, :each_slice, :each_with_index, :each_with_object, :entries, :filter, :filter_map, :find, :find_all, :find_index, :first, :flat_map, :grep, :grep_v, :group_by, :include?, :inject, :lazy, :map, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :none?, :one?, :partition, :reduce, :reject, :reverse_each, :select, :slice_after, :slice_before, :slice_when, :sort, :sort_by, :sum]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # chain
  # collect
  # collect_concat
  # compact
  # cycle
  # detect
  # each_cons
  # each_entry
  # each_slice
  # each_with_index
  # each_with_object
  # entries
  # find_all
  # first
  # grep
  # grep_v
  # include?
  # inject
  # lazy
  # minmax
  # minmax_by
  # none?
  # one?
  # reverse_each
  # select
  # slice_after
  # slice_before
  # slice_when
  # TODO:
end
