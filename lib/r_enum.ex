defmodule REnum do
  @moduledoc """
  Entry point of Enum extensions, and can use all of REnum.* functions.
  See also
   - [REnum.Native](https://hexdocs.pm/r_enum/REnum.Native.html#content)
   - [REnum.Ruby](https://hexdocs.pm/r_enum/REnum.Ruby.html#content)
   - [REnum.ActiveSupport](https://hexdocs.pm/r_enum/REnum.ActiveSupport.html#content)
   - [REnum.Support](https://hexdocs.pm/r_enum/REnum.Support.html#content)
  """
  defmacro __using__(opts) do
    undelegate_functions = Keyword.get(opts, :undelegate_functions, [])
    RUtils.define_all_functions!(__MODULE__, elem(Code.eval_quoted(undelegate_functions), 0))
  end

  use REnum.Native
  use REnum.Ruby
  use REnum.ActiveSupport
  use REnum.Support
end
