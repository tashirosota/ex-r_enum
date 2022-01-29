defmodule RMap do
  @moduledoc """
  Entry point of Map extensions, and can use all of RMap.* and REnum functions.
  See also.
   - [RMap.Native](https://hexdocs.pm/r_enum/RMap.Native.html#content)
   - [RMap.Ruby](https://hexdocs.pm/r_enum/RMap.Ruby.html#content)
   - [RMap.ActiveSupport](https://hexdocs.pm/r_enum/RMap.ActiveSupport.html#content)
   - [RMap.Support](https://hexdocs.pm/r_enum/RMap.Support.html#content)
   - [REnum](https://hexdocs.pm/r_enum/REnum.html#content)
  """
  use RMap.Native
  use RMap.Ruby
  use RMap.ActiveSupport
  use RMap.Support

  use REnum,
    undelegate_functions:
      (Map.module_info()[:exports] |> Keyword.keys()) ++ [:select, :filter, :reject]
end
