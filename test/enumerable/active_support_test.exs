defmodule REnum.Enumerable.ActiveSupportTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest REnum.Enumerable.ActiveSupport

  describe "compact_blank/1" do
    test "when list" do
      assert REnum.compact_blank([1, "", nil, 2, " ", [], %{}, false, true]) == [1, 2, true]
    end

    test "when map" do
      assert REnum.compact_blank(%{a: "", b: 1, c: nil, d: [], e: false, f: true}) == %{
               b: 1,
               f: true
             }
    end
  end
end
