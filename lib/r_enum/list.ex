defmodule REnum.List do
  @moduledoc """
  Entry point of List extensions, and can use all of REnum.List.* functions.
  See also.
   - [REnum.Stream.Native](https://hexdocs.pm/r_enum/REnum.List.Native.html#content)
  """
  use REnum.List.Native
  use REnum.List.Ruby
  use REnum.List.ActiveSupport
end
