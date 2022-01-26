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

  # https://www.rubydoc.info/gems/activesupport/Array
  # [:as_json, :compact_blank!, :deep_dup, :excluding, :extract!, :extract_options!, :fifth, :forty_two, :fourth, :from, :in_groups, :in_groups_of, :including, :inquiry, :second, :second_to_last, :split, :sum, :third, :third_to_last, :to, :to_default_s, :to_formatted_s, :to_param, :to_query, :to_s, :to_sentence, :to_xml]
  # |> RUtils.required_functions([List, REnum])
  # × as_json
  # × deep_dup
  # ✔ fifth
  # ✔ forty_two
  # ✔ fourth
  # ✔ from
  # in_groups
  # in_groups_of
  # inquiry
  # ✔ second
  # ✔ second_to_last
  # ✔ third
  # ✔ third_to_last
  # ✔ to
  # to_default_s
  # to_formatted_s
  # to_param
  # to_query
  # to_s
  # to_sentence
  # to_xml

  @doc """
  Returns the tail of the list from position.
  ## Examples
      iex> ~w[a b c d]
      ...> |> RList.from(0)
      ["a", "b", "c", "d"]

      iex> ~w[a b c d]
      ...> |> RList.from(2)
      ["c", "d"]

      iex> ~w[a b c d]
      ...> |> RList.from(10)
      []

      iex> ~w[]
      ...> |> RList.from(0)
      []

      iex> ~w[a b c d]
      ...> |> RList.from(-2)
      ["c", "d"]

      iex> ~w[a b c d]
      ...> |> RList.from(-10)
      []
  """
  @spec from(list(), integer()) :: list()
  def from(list, position) do
    list
    |> Enum.slice(position..Enum.count(list))
  end

  @doc """
  Returns the beginning of the list up to position.
  ## Examples
      iex> ~w[a b c d]
      ...> |> RList.to(0)
      ["a"]

      iex> ~w[a b c d]
      ...> |> RList.to(2)
      ["a", "b", "c"]

      iex> ~w[a b c d]
      ...> |> RList.to(10)
      ["a", "b", "c", "d"]

      iex> ~w[]
      ...> |> RList.to(0)
      []

      iex> ~w[a b c d]
      ...> |> RList.to(-2)
      ["a", "b", "c"]

      iex> ~w[a b c d]
      ...> |> RList.to(-10)
      []
  """
  @spec to(list(), integer()) :: list()
  def to(list, position) do
    list
    |> Enum.slice(0..position)
  end

  @doc """
  Equal to `Enum.at(list, 1)`.
  ## Examples
      iex> ~w[a b c d]
      ...> |> RList.second()
      "b"
  """
  @spec second(list()) :: any()
  def second(list) do
    Enum.at(list, 1)
  end

  @doc """
  Equal to `Enum.at(list, 2)`.
  ## Examples
      iex> ~w[a b c d]
      ...> |> RList.third()
      "c"
  """
  @spec third(list()) :: any()
  def third(list) do
    Enum.at(list, 2)
  end

  @doc """
  Equal to `Enum.at(list, 3)`.
  ## Examples
      iex> ~w[a b c d]
      ...> |> RList.fourth()
      "d"
  """
  @spec fourth(list()) :: any()
  def fourth(list) do
    Enum.at(list, 3)
  end

  @doc """
  Equal to `Enum.at(list, 4)`.
  ## Examples
      iex> ~w[a b c d e]
      ...> |> RList.fifth()
      "e"
  """
  @spec fifth(list()) :: any()
  def fifth(list) do
    Enum.at(list, 4)
  end

  @doc """
  Equal to `Enum.at(list, 41)`. Also known as accessing "the reddit".
  ## Examples
      iex> 1..42
      ...> |> RList.forty_two()
      42
  """
  @spec forty_two(list()) :: any()
  def forty_two(list) do
    Enum.at(list, 41)
  end

  @doc """
  Equal to `Enum.at(list, -2)`.
  ## Examples
      iex> ~w[a b c d e]
      ...> |> RList.second_to_last()
      "d"
  """
  @spec second_to_last(list()) :: any()
  def second_to_last(list) do
    Enum.at(list, -2)
  end

  @doc """
  Equal to `Enum.at(list, -3)`.
  ## Examples
      iex> ~w[a b c d e]
      ...> |> RList.third_to_last()
      "c"
  """
  @spec third_to_last(list()) :: any()
  def third_to_last(list) do
    Enum.at(list, -3)
  end
end
