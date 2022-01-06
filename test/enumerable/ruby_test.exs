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

  test "select/2" do
    assert Rubenum.select(1..3, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..3, fn x -> rem(x, 2) == 0 end)

    assert Rubenum.select(1..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..6, fn x -> rem(x, 2) == 0 end)

    assert Rubenum.select(1..3, &match?(1, &1)) == Enum.filter(1..3, &match?(1, &1))

    assert Rubenum.select(1..3, &match?(x when x < 3, &1)) ==
             Enum.filter(1..3, &match?(x when x < 3, &1))

    assert Rubenum.select(1..3, fn _ -> true end) == Enum.filter(1..3, fn _ -> true end)
  end

  test "find_all/2" do
    assert Rubenum.find_all(1..3, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..3, fn x -> rem(x, 2) == 0 end)

    assert Rubenum.find_all(1..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..6, fn x -> rem(x, 2) == 0 end)

    assert Rubenum.find_all(1..3, &match?(1, &1)) == Enum.filter(1..3, &match?(1, &1))

    assert Rubenum.find_all(1..3, &match?(x when x < 3, &1)) ==
             Enum.filter(1..3, &match?(x when x < 3, &1))

    assert Rubenum.find_all(1..3, fn _ -> true end) == Enum.filter(1..3, fn _ -> true end)
  end

  test "inject/2" do
    assert Rubenum.inject([1, 2, 3], fn x, acc -> x + acc end) ==
             Enum.reduce([1, 2, 3], fn x, acc -> x + acc end)

    assert_raise Enum.EmptyError, fn ->
      Rubenum.inject([], fn x, acc -> x + acc end)
    end

    assert_raise Enum.EmptyError, fn ->
      Rubenum.inject(%{}, fn _, acc -> acc end)
    end
  end

  test "inject/3" do
    assert Rubenum.inject([], 1, fn x, acc -> x + acc end) ==
             Enum.reduce([], 1, fn x, acc -> x + acc end)

    assert Rubenum.inject([1, 2, 3], 1, fn x, acc -> x + acc end) ==
             Enum.reduce([1, 2, 3], 1, fn x, acc -> x + acc end)
  end

  test "collect/2" do
    assert Rubenum.collect([], fn x -> x * 2 end) == Enum.map([], fn x -> x * 2 end)
    assert Rubenum.collect([1, 2, 3], fn x -> x * 2 end) == Enum.map([1, 2, 3], fn x -> x * 2 end)
  end

  test "first/1" do
    assert Rubenum.first([]) == nil
    assert Rubenum.first([1, 2, 3]) == 1
    assert Rubenum.first(%{}) == nil
    assert Rubenum.first(%{a: 1, b: 2}) == [:a, 1]
  end

  test "first/2" do
    assert Rubenum.first([], 2) == []
    assert Rubenum.first([1, 2, 3], 2) == [1, 2]
    assert Rubenum.first(%{}, 2) == []
    assert Rubenum.first(%{a: 1, b: 2}, 2) == [[:a, 1], [:b, 2]]
  end
end
