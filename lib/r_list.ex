defmodule RList do
  @moduledoc """
  Entry point of List extensions, and can use all of RList.* and REnum functions.
  See also.
   - [RList.Native](https://hexdocs.pm/r_enum/RList.Native.html#content)
   - [RList.Ruby](https://hexdocs.pm/r_enum/RList.Ruby.html#content)
   - [RList.ActiveSupport](https://hexdocs.pm/r_enum/RList.ActiveSupport.html#content)
   - [REnum](https://hexdocs.pm/r_enum/REnum.html#content)
  """
  use RList.Native
  use RList.Ruby
  use RList.ActiveSupport
  use RList.Support
  use REnum, undelegate_functions: List.module_info()[:exports] |> Keyword.keys()
end
