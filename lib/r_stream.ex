defmodule RStream do
  @moduledoc """
  Entry point of Stream extensions, and can use all of RStream.* and REnum functions.
  See also.
   - [RStream.Native](https://hexdocs.pm/r_enum/RStream.Native.html#content)
   - [REnum](https://hexdocs.pm/r_enum/REnum.html#content)
  """
  use RStream.Native
  use RStream.Ruby
  use RStream.ActiveSupport
  use REnum, undelegate_functions: Stream.module_info()[:exports] |> Keyword.keys()
end
