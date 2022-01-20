defmodule RMap do
  @moduledoc """
  Entry point of Map extensions, and can use all of RMap.* and REnum functions.
  See also.
   - [RStream.Native](https://hexdocs.pm/r_enum/RMap.Native.html#content)
  """
  use RMap.Native
  use RMap.Ruby
  use RMap.ActiveSupport
  use REnum, undelegate_functions: Map.module_info()[:exports] |> Keyword.keys()
end
