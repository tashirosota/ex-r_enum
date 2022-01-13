defmodule REnum do
  @moduledoc """
  Entry point of Enum extensions, and can use all of REnum.Enumerable.* functions.
  See also
   - [REnum.Enumerable.Native](https://hexdocs.pm/r_enum/REnum.Enumerable.Native.html#content)
   - [REnum.Enumerable.Ruby](https://hexdocs.pm/r_enum/REnum.Enumerable.Ruby.html#content)
   - [REnum.Enumerable.Support](https://hexdocs.pm/r_enum/REnum.Enumerable.Support.html#content)
  """
  use REnum.Enumerable.Native
  use REnum.Enumerable.Ruby
  use REnum.Enumerable.ActiveSupport
  use REnum.Enumerable.Support
end
