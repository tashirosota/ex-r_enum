defmodule RRange.RubyEnd do
  defmacro __using__(_opts) do
    quote do
      def last(_..last) do
        last
      end

      defdelegate unquote(:end)(range), to: __MODULE__, as: :last
    end
  end
end
