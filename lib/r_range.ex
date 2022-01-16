defmodule RRange do
  @moduledoc """
  Entry point of Range extensions, and can use all of RRange.* functions.
  See also.
   - [RRange.Native](https://hexdocs.pm/r_enum/RRange.Native.html#content)
  """
  use RRange.Native
  use RRange.Ruby
  use RRange.ActiveSupport
end
