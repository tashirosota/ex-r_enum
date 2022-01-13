defmodule REnum.Map do
  @moduledoc """
  Entry point of Map extensions, and can use all of REnum.Map.* functions.
  See also.
   - [REnum.Stream.Native](https://hexdocs.pm/r_enum/REnum.Map.Native.html#content)
  """
  use REnum.Map.Native
  use REnum.Map.Ruby
  use REnum.Map.ActiveSupport
end
