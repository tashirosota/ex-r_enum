defmodule RRange.RubyEnd do
  @spec __using__(any) ::
          {:__block__, [],
           [{:@, [...], [...]} | {:def, [...], [...]} | {:defdelegate, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      @doc """
      Returns the last element of range.
      ## Examples
          iex> RList.last(1..3)
          3
      """
      @spec last(Range.t()) :: integer()
      def last(_..last) do
        last
      end

      defdelegate unquote(:end)(range), to: __MODULE__, as: :last
    end
  end
end
