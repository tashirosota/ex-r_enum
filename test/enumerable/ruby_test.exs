defmodule Rubenum.Enumerable.RubyTest do
  use ExUnit.Case
  doctest Rubenum.Enumerable.Ruby

  describe "compact/1" do
    test "when list" do
      assert Rubenum.compact([1, 2, 4]) == [1, 2, 4]
      assert Rubenum.compact([1, nil, 2, 4]) == [1, 2, 4]
      assert Rubenum.compact([1, 2, 4, nil]) == [1, 2, 4]
      assert Rubenum.compact([nil, 1, 2, 4]) == [1, 2, 4]
    end

    test "when map" do
      assert Rubenum.compact(%{
               :truthy => true,
               false => false,
               nil => nil,
               nil => true,
               :map => %{key: :value}
             }) == %{
               :truthy => true,
               false => false,
               nil => true,
               :map => %{key: :value}
             }
    end
  end

  test "detect/3" do
    assert Rubenum.detect(2..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.find(2..6, fn x -> rem(x, 2) == 0 end)

    assert Rubenum.detect(2..6, fn x -> rem(x, 2) == 1 end) ==
             Enum.find(2..6, fn x -> rem(x, 2) == 1 end)

    assert Rubenum.detect(2..6, fn _ -> false end) == Enum.find(2..6, fn _ -> false end)
    assert Rubenum.detect(2..6, 0, fn _ -> false end) == Enum.find(2..6, 0, fn _ -> false end)
  end
end
