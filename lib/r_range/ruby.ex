defmodule RRange.Ruby do
  @moduledoc """
  Summarized all of Ruby's Range functions.
  Functions corresponding to the following patterns are not implemented
   - When a function with the same name already exists in Elixir.
   - When a method name includes `!`.
   - %, ==, ===
  """
  @spec __using__(any) :: list
  defmacro __using__(_opts) do
    RUtils.define_all_functions!(__MODULE__)
  end

  use RRange.RubyEnd

  # https://ruby-doc.org/core-3.1.0/Range.html
  # [:begin, :bsearch, :count, :cover?, :each, :end, :entries, :eql?, :exclude_end?, :first, :hash, :include?, :inspect, :last, :max, :member?, :min, :minmax, :size, :step, :to_a, :to_s]
  # |> RUtils.required_functions([Range, REnum])
  # ✔ begin
  # × bsearch
  # ✔ cover?
  # ✔ end
  # ✔ eql?
  # × exclude_end?
  # × hash
  # ✔ inspect
  # ✔ last
  # ✔ step
  # ✔ to_s

  @doc """
  Returns true if list1 == list2.
  ## Examples
      iex> 1..3
      iex> |> RList.eql?(1..3)
      true

      iex> 1..3
      iex> |> RList.eql?(1..4)
      false
  """
  @spec eql?(Range.t(), Range.t()) :: boolean()
  def eql?(range1, range2) do
    range1 == range2
  end

  @doc """
  Returns the first element of range.
  ## Examples
      iex> RList.begin(1..3)
      1
  """
  @spec begin(Range.t()) :: integer()
  def begin(begin.._) do
    begin
  end

  if(VersionManager.support_version?()) do
    @doc """
    Returns Stream that from given range split into by given step.
    ## Examples
        iex> RList.step(1..10, 2)
        iex> |> Enum.to_list()
        [1, 3, 5, 7, 9]
    """
    @spec step(Range.t(), integer()) :: Enum.t()
    def step(begin..last, step) do
      begin..last//step
      |> REnum.Ruby.lazy()
    end

    @doc """
    Executes `Enum.each` to g given range split into by given step.
    ## Examples
        iex> RList.step(1..10, 2, &IO.inspect(&1))
        iex> |> Enum.to_list()
        # 1
        # 3
        # 5
        # 7
        # 9
        :ok
    """
    @spec step(Range.t(), integer(), function()) :: :ok
    def step(begin..last, step, func) do
      begin..last//step
      |> Enum.each(func)
    end
  end

  defdelegate inspect(range), to: Kernel, as: :inspect
  defdelegate to_s(range), to: Kernel, as: :inspect
  defdelegate cover?(range, n), to: Enum, as: :member?
end
