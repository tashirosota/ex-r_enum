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

  describe "one?" do
    test "one?/1" do
      assert Rubenum.one?(1..1) == true
      assert Rubenum.one?([1, nil, false]) == true
      assert Rubenum.one?(1..4) == false
      assert Rubenum.one?(%{foo: 0}) == true
      assert Rubenum.one?(%{foo: 0, bar: 1}) == false
      assert Rubenum.one?([]) == false
    end

    test "one?/2 when is_function" do
      assert Rubenum.one?(1..4, &(&1 < 2)) == true
      assert Rubenum.one?(1..4, &(&1 < 1)) == false
      assert Rubenum.one?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 1 end) == true
      assert Rubenum.one?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 2 end) == false
    end
  end

  describe "none?" do
    test "none?/1" do
      assert Rubenum.none?(1..4) == false
      assert Rubenum.none?([nil, false]) == true
      assert Rubenum.none?(%{foo: 0}) == false
      assert Rubenum.none?(%{foo: 0, bar: 1}) == false
      assert Rubenum.none?([]) == true
    end

    test "none?/2 when is_function" do
      assert Rubenum.none?(1..4, &(&1 < 1)) == true
      assert Rubenum.none?(1..4, &(&1 < 2)) == false
      assert Rubenum.none?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 0 end) == true
      assert Rubenum.none?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 1 end) == false
    end
  end

  test "include?/2" do
    assert Rubenum.include?(1..3, 2)
    refute Rubenum.include?(1..3, 0)

    assert Rubenum.include?(1..9//2, 1)
    assert Rubenum.include?(1..9//2, 9)
    refute Rubenum.include?(1..9//2, 10)
    refute Rubenum.include?(1..10//2, 10)
    assert Rubenum.include?(1..2//2, 1)
    refute Rubenum.include?(1..2//2, 2)

    assert Rubenum.include?(-1..-9//-2, -1)
    assert Rubenum.include?(-1..-9//-2, -9)
    refute Rubenum.include?(-1..-9//-2, -8)

    refute Rubenum.include?(1..0//1, 1)
    refute Rubenum.include?(0..1//-1, 1)
  end

  test "collect_concat/2" do
    assert Rubenum.collect_concat([], fn x -> [x, x] end) == []
    assert Rubenum.collect_concat([1, 2, 3], fn x -> [x, x] end) == [1, 1, 2, 2, 3, 3]
    assert Rubenum.collect_concat([1, 2, 3], fn x -> x..(x + 1) end) == [1, 2, 2, 3, 3, 4]
  end

  @tag :skip
  test "cycle/2" do
  end

  @tag :skip
  test "cycle/3" do
  end
end
