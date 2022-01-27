defmodule RMap.RubyTest do
  use ExUnit.Case
  doctest RMap.Ruby

  describe "alias" do
    test "delete_if/2" do
      map = %{a: 1, b: 2, c: 3}

      assert RMap.delete_if(map, fn {_, v} -> v > 1 end) ==
               RMap.reject(map, fn {_, v} -> v > 1 end)

      assert RMap.delete_if(map, fn {_, v} -> v == 2 end) ==
               RMap.reject(map, fn {_, v} -> v == 2 end)

      assert RMap.delete_if(%{}, fn {_, v} -> !!v end) == RMap.reject(%{}, fn {_, v} -> !!v end)
    end

    test "keep_if/2" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.keep_if(map, fn {_, v} -> v > 1 end) == RMap.filter(map, fn {_, v} -> v > 1 end)

      assert RMap.keep_if(map, fn {_, v} -> v == 2 end) ==
               RMap.filter(map, fn {_, v} -> v == 2 end)

      assert RMap.keep_if(%{}, fn {_, v} -> !!v end) == RMap.filter(%{}, fn {_, v} -> !!v end)
    end

    test "select/2" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.select(map, fn {_, v} -> v > 1 end) == RMap.filter(map, fn {_, v} -> v > 1 end)

      assert RMap.select(map, fn {_, v} -> v == 2 end) ==
               RMap.filter(map, fn {_, v} -> v == 2 end)

      assert RMap.select(%{}, fn {_, v} -> !!v end) == RMap.filter(%{}, fn {_, v} -> !!v end)
    end

    test "length/1" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.length(map) == Enum.count(map)
      assert RMap.length(%{}) == Enum.count(%{})
    end

    test "size/1" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.size(map) == Enum.count(map)
      assert RMap.size(%{}) == Enum.count(%{})
    end

    test "to_s/1" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.to_s(map) == Kernel.inspect(map)
      assert RMap.to_s(%{}) == Kernel.inspect(%{})
    end

    test "inspect/1" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.inspect(map) == Kernel.inspect(map)
      assert RMap.inspect(%{}) == Kernel.inspect(%{})
    end

    test "each_pair/1" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.each_pair(map, &IO.inspect(&1)) == Enum.each(map, &IO.inspect(&1))
      assert RMap.each_pair(%{}, &IO.inspect(&1)) == Enum.each(%{}, &IO.inspect(&1))
    end

    test "key/3" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.key(map, :a) == Map.get(map, :a)
      assert RMap.key(%{}, :a, 2) == Map.get(%{}, :a, 2)
    end

    test "key?/2" do
      map = %{a: 1, b: 2, c: 3}
      assert RMap.key?(map, :a) == Map.has_key?(map, :a)
      assert RMap.key?(%{}, :a) == Map.has_key?(%{}, :a)
    end
  end
end
