defmodule RList do
  @moduledoc """
  Entry point of List extensions, and can use all of RList.* and REnum functions.
  See also.
   - [RList.Native](https://hexdocs.pm/r_enum/RList.Native.html#content)
   - [RList.Ruby](https://hexdocs.pm/r_enum/RList.Ruby.html#content)
   - [REnum](https://hexdocs.pm/r_enum/REnum.html#content)
  """
  use RList.Native
  use RList.Ruby
  use RList.ActiveSupport
  use REnum, undelegate_functions: List.module_info()[:exports] |> Keyword.keys()
end
