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

  def eql?(range1, range2) do
    range1 == range2
  end

  def begin(begin.._) do
    begin
  end

  def step(begin..last, step) do
    begin..last//step
    |> REnum.Ruby.lazy()
  end

  def step(begin..last, step, func) do
    begin..last//step
    |> Enum.each(func)
  end

  defdelegate inspect(range), to: Kernel, as: :inspect
  defdelegate to_s(range), to: Kernel, as: :inspect
  defdelegate cover?(range, n), to: Enum, as: :member?
end
