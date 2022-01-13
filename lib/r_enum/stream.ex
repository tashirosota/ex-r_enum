defmodule REnum.Stream do
  @moduledoc """
  Entry point of Stream extensions, and can use all of REnum.Stream.* functions.
  See also.
   - [REnum.Stream.Native](https://hexdocs.pm/r_enum/REnum.Stream.Native.html#content)
  """
  use REnum.Stream.Native
  use REnum.Stream.Ruby
  use REnum.Stream.ActiveSupport
end
