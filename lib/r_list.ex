defmodule RList do
  @moduledoc """
  Entry point of List extensions, and can use all of RList.* and REnum functions.
  See also.
   - [RStream.Native](https://hexdocs.pm/r_enum/RList.Native.html#content)
  """
  use RList.Native
  use RList.Ruby
  use RList.ActiveSupport
  use REnum, undelegate_functions: List.module_info()[:exports] |> Keyword.keys()
end
