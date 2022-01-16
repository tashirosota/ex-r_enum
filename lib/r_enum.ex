defmodule REnum do
  @moduledoc """
  Entry point of Enum extensions, and can use all of REnum.* functions.
  See also
   - [REnum.Native](https://hexdocs.pm/r_enum/REnum.Native.html#content)
   - [REnum.Ruby](https://hexdocs.pm/r_enum/REnum.Ruby.html#content)
   - [REnum.Support](https://hexdocs.pm/r_enum/REnum.Support.html#content)
  """
  use REnum.Native
  use REnum.Ruby
  use REnum.ActiveSupport
  use REnum.Support
end
