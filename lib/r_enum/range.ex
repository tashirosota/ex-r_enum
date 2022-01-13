defmodule REnum.Range do
  @moduledoc """
  Entry point of Range extensions, and can use all of REnum.Range.* functions.
  See also.
   - [REnum.Range.Native](https://hexdocs.pm/r_enum/REnum.Range.Native.html#content)
  """
  use REnum.Range.Native
  use REnum.Range.Ruby
  use REnum.Range.ActiveSupport
end
