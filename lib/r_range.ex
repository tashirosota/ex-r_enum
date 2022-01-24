defmodule RRange do
  @moduledoc """
  Entry point of Range extensions, and can use all of RRange.* and REnum functions.
  See also.
   - [RRange.Native](https://hexdocs.pm/r_enum/RRange.Native.html#content)
   - [REnum](https://hexdocs.pm/r_enum/REnum.html#content)
  """
  use RRange.Native
  use RRange.Ruby
  use RRange.ActiveSupport
  use REnum, undelegate_functions: Range.module_info()[:exports] |> Keyword.keys()
end
