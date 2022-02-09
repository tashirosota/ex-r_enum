defmodule VersionManager do
  @moduledoc false
  def support_version? do
    Version.match?(System.version(), ">= 1.12.0")
  end
end
