defmodule RStream do
  @moduledoc """
  Entry point of Stream extensions, and can use all of RStream.* functions.
  See also.
   - [RStream.Native](https://hexdocs.pm/r_enum/RStream.Native.html#content)
  """
  use RStream.Native
  use RStream.Ruby
  use RStream.ActiveSupport
end
