defmodule RList.ActiveSupport do
  @moduledoc """
  Summarized all of List functions in Rails.ActiveSupport.
  If a function with the same name already exists in Elixir, that is not implemented.
  Defines all of here functions when `use RList.ActiveSupport`.
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  alias RList.Support

  # https://www.rubydoc.info/gems/activesupport/Array
  # [:as_json, :compact_blank!, :deep_dup, :excluding, :extract!, :extract_options!, :fifth, :forty_two, :fourth, :from, :in_groups, :in_groups_of, :including, :inquiry, :second, :second_to_last, :split, :sum, :third, :third_to_last, :to, :to_default_s, :to_formatted_s, :to_param, :to_query, :to_s, :to_sentence, :to_xml]
  # |> RUtils.required_functions([List, RList.Ruby, REnum])
  # × as_json
  # × deep_dup
  # ✔ fifth
  # ✔ forty_two
  # ✔ fourth
  # ✔ from
  # ✔ in_groups
  # ✔ in_groups_of
  # inquiry
  # ✔ second
  # ✔ second_to_last
  # ✔ third
  # ✔ third_to_last
  # ✔ to
  # ✔ to_default_s
  # × to_formatted_s
  # to_param
  # to_query
  # ✔ to_sentence
  # to_xml

  @doc """
  Returns the tail of the list from position.
  ## Examples
      iex> ~w[a b c d]
      iex> |> RList.from(0)
      ["a", "b", "c", "d"]

      iex> ~w[a b c d]
      iex> |> RList.from(2)
      ["c", "d"]

      iex> ~w[a b c d]
      iex> |> RList.from(10)
      []

      iex> ~w[]
      iex> |> RList.from(0)
      []

      iex> ~w[a b c d]
      iex> |> RList.from(-2)
      ["c", "d"]

      iex> ~w[a b c d]
      iex> |> RList.from(-10)
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
      iex> |> RList.to(0)
      ["a"]

      iex> ~w[a b c d]
      iex> |> RList.to(2)
      ["a", "b", "c"]

      iex> ~w[a b c d]
      iex> |> RList.to(10)
      ["a", "b", "c", "d"]

      iex> ~w[]
      iex> |> RList.to(0)
      []

      iex> ~w[a b c d]
      iex> |> RList.to(-2)
      ["a", "b", "c"]

      iex> ~w[a b c d]
      iex> |> RList.to(-10)
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
      iex> |> RList.second()
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
      iex> |> RList.third()
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
      iex> |> RList.fourth()
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
      iex> |> RList.fifth()
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
      iex> |> RList.forty_two()
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
      iex> |> RList.second_to_last()
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
      iex> |> RList.third_to_last()
      "c"
  """
  @spec third_to_last(list()) :: any()
  def third_to_last(list) do
    Enum.at(list, -3)
  end

  @doc """
  Converts the list to a comma-separated sentence where the last element is
  joined by the connector word.

  You can pass the following options to change the default behavior. If you
  pass an option key that doesn't exist in the list below, it will raise an

  ** Options **
  * `:words_connector` - The sign or word used to join all but the last
    element in lists with three or more elements (default: ", ").
  * `:last_word_connector` - The sign or word used to join the last element
    in lists with three or more elements (default: ", and ").
  * `:two_words_connector` - The sign or word used to join the elements
    in lists with two elements (default: " and ").

  ## Examples
      iex> ["one", "two"]
      iex> |> RList.to_sentence()
      "one and two"

      iex> ["one", "two", "three"]
      iex> |> RList.to_sentence()
      "one, two, and three"

      iex> ["one", "two"]
      iex> |> RList.to_sentence(two_words_connector: "-")
      "one-two"

      iex> ["one", "two", "three"]
      iex> |> RList.to_sentence(words_connector: " or ", last_word_connector: " or at least ")
      "one or two or at least three"

      iex> ["one", "two", "three"]
      iex> |> RList.to_sentence()
      "one, two, and three"
  """
  @spec to_sentence(list(), list(keyword()) | nil) :: String.t()
  def to_sentence(list, opts \\ []) do
    words_connector = Keyword.get(opts, :words_connector) || ", "
    two_words_connector = Keyword.get(opts, :two_words_connector) || " and "
    last_word_connector = Keyword.get(opts, :last_word_connector) || ", and "

    case Enum.count(list) do
      0 -> ""
      1 -> "#{Enum.at(list, 0)}"
      2 -> "#{Enum.at(list, 0)}#{two_words_connector}#{Enum.at(list, 1)}"
      _ -> "#{to(list, -2) |> Enum.join(words_connector)}#{last_word_connector}#{List.last(list)}"
    end
  end

  @doc """
  Splits or iterates over the list in number of groups, padding any remaining slots with fill_with unless it is false.
  ## Examples
      iex> ~w[1 2 3 4 5 6 7 8 9 10]
      iex> |> RList.in_groups(3)
      [
        ["1", "2", "3", "4"],
        ["5", "6", "7", nil],
        ["8", "9", "10", nil]
      ]

      iex> ~w[1 2 3 4 5 6 7 8 9 10]
      iex> |> RList.in_groups(3, "&nbsp;")
      [
        ["1", "2", "3", "4"],
        ["5", "6", "7", "&nbsp;"],
        ["8", "9", "10", "&nbsp;"]
      ]

      iex> ~w[1 2 3 4 5 6 7]
      iex> |> RList.in_groups(3, false)
      [
        ["1", "2", "3"],
        ["4", "5"],
        ["6", "7"]
      ]
  """
  @spec in_groups(list(), non_neg_integer(), any() | nil) :: list()
  def in_groups(list, number, fill_with \\ nil) do
    division = div(Enum.count(list), number)
    modulo = rem(Enum.count(list), number)
    range = 0..(number - 1)

    length_list =
      range
      |> Enum.map(&(division + if(modulo > 0 && modulo > &1, do: 1, else: 0)))
      |> IO.inspect()

    range
    |> Enum.reduce([], fn index, acc ->
      length = length_list |> Enum.at(index)

      group =
        Enum.slice(
          list,
          length_list
          |> Enum.take(index)
          |> Enum.sum(),
          length
        )

      if fill_with != false && modulo > 0 && length == division do
        acc ++ [group ++ [fill_with]]
      else
        acc ++ [group]
      end
    end)
  end

  @doc """
  Splits or iterates over the list in groups of size number, padding any remaining slots with fill_with unless it is +false+.
  ## Examples
      iex> ~w[1 2 3 4 5 6 7 8 9 10]
      iex> |> RList.in_groups_of(3)
      [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["10", nil, nil]
      ]

      iex> ~w[1 2 3 4 5]
      iex> |> RList.in_groups_of(2, "&nbsp;")
      [
        ["1", "2"],
        ["3", "4"],
        ["5", "&nbsp;"]
      ]

      iex> ~w[1 2 3 4 5]
      iex> |> RList.in_groups_of(2, false)
      [
        ["1", "2"],
        ["3", "4"],
        ["5"]
      ]
  """
  @spec in_groups_of(list(), non_neg_integer(), any() | nil) :: list()
  def in_groups_of(list, number, fill_with \\ nil) do
    if(fill_with == false) do
      list
    else
      padding = rem(number - rem(Enum.count(list), number), number)
      list ++ Support.new(fill_with, padding)
    end
    |> REnum.each_slice(number)
    |> Enum.to_list()
  end

  defdelegate to_default_s(list), to: Kernel, as: :inspect
end
