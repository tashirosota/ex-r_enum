defmodule REnum.Enumerable.ActiveSupport do
  import REnum.Utils
  import REnum.Enumerable.Support

  @moduledoc """
  Unimplemented.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    define_all_functions!(__MODULE__)
  end

  @type type_enumerable :: Enumerable.t()
  @type type_pattern :: number() | String.t() | Range.t() | Regex.t()

  # https://www.rubydoc.info/gems/activesupport/Enumerable
  # ruby_enumerable = [:as_json, :compact_blank, :exclude?, :excluding, :in_order_of, :including, :index_by, :index_with, :many?, :maximum, :minimum, :pick, :pluck, :sole, :without]
  # |> Enum.reject(fn method ->
  #   Enum.module_info()[:exports]
  #   |> Keyword.keys()
  #   |> Enum.find(&(&1 == method))
  # end)
  # as_json
  # ✔ compact_blank
  # ✔ exclude?
  # ✔ excluding
  # in_order_of
  # ✔ including
  # index_by
  # index_with
  # many?
  # maximum
  # minimum
  # pick
  # pluck
  # sole
  # ✔ without

  @spec compact_blank(type_enumerable) :: type_enumerable
  def compact_blank(enumerable) when is_list(enumerable) do
    enumerable
    |> Enum.reject(&(&1 |> blank?()))
  end

  def compact_blank(enumerable) when is_map(enumerable) do
    enumerable
    |> Enum.reject(fn {_, value} ->
      blank?(value)
    end)
    |> Enum.into(%{})
  end

  @spec exclude?(type_enumerable, any()) :: type_enumerable
  def exclude?(enumerable, element) do
    !Enum.member?(enumerable, element)
  end

  @spec excluding(type_enumerable, type_enumerable) :: type_enumerable
  def excluding(enumerable, elements) do
    cond do
      map_and_not_range?(enumerable) ->
        enumerable
        |> Enum.filter(fn {key, _} ->
          exclude?(elements, key)
        end)
        |> Map.new()

      true ->
        enumerable
        |> Enum.filter(fn el ->
          elements
          |> exclude?(el)
        end)
    end
  end

  @spec including(type_enumerable, type_enumerable) :: type_enumerable
  def including(enumerable, elements) do
    (enumerable |> Enum.to_list()) ++ (elements |> Enum.to_list())
  end

  defdelegate without(enumerable, elements), to: __MODULE__, as: :excluding
end
