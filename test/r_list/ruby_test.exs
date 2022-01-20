defmodule RList.RubyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest RList.Ruby

  test "all?/1" do
    assert RList.all?([2, 4, 6])
    refute RList.all?([2, nil, 4])
    assert RList.all?([])
  end

  describe "all?/2" do
    test "when function" do
      assert RList.all?([2, 4, 6], fn x -> rem(x, 2) == 0 end)
      refute RList.all?([2, 3, 4], fn x -> rem(x, 2) == 0 end)
    end

    test "when pattern" do
      assert RList.all?([2, 2, 2], 2)
      assert RList.all?(["120", "2", "12"], ~r/2/)
      assert RList.all?([2, 3, 4], 2..5)
      refute RList.all?([2, 3, 4], 3..5)
    end
  end

  test "any?/1" do
    refute RList.any?([false, false, false])
    assert RList.any?([false, true, false])

    assert RList.any?([:foo, false, false])
    refute RList.any?([false, nil, false])

    refute RList.any?([])
  end

  describe "any?/2" do
    test "when function" do
      refute RList.any?([2, 4, 6], fn x -> rem(x, 2) == 1 end)
      assert RList.any?([2, 3, 4], fn x -> rem(x, 2) == 1 end)
    end

    test "when pattern" do
      assert RList.any?([2, 2, 2], 2)
      assert RList.any?(["120", "2", "12"], ~r/12/)
      assert RList.any?([2, 3, 4], 2..5)
      refute RList.any?([2, 3, 4], 5..10)
    end
  end

  test "push/2" do
    assert RList.push([1], 2) == [1, 2]
    assert RList.push([1], 1..3) == [1, 1..3]
    assert RList.push([1], [2, 3]) == [1, 2, 3]
    assert RList.push([1], %{a: 1}) == [1, %{a: 1}]
  end

  test "append/2" do
    assert RList.push([1], 2) == RList.append([1], 2)
    assert RList.push([1], 1..3) == RList.append([1], 1..3)
    assert RList.push([1], [2, 3]) == RList.append([1], [2, 3])
    assert RList.push([1], %{a: 1}) == RList.append([1], %{a: 1})
  end

  test "assoc/2" do
    a = %{foo: 0}
    b = [1, 15]
    c = [2, 25]
    d = [3, 35]
    list = [a, b, c, d]
    assert RList.assoc(list, 2) == c
    assert RList.assoc(list, 100) == nil
    assert RList.assoc(list, {:foo, 0}) == a
  end

  test "clear/1" do
    assert RList.clear([1]) == []
    assert RList.clear([]) == []
  end

  test "at/2" do
    assert RList.at([1], 2) == Enum.at([1], 2)
    assert RList.at(0..3, 2) == Enum.at(0..3, 2)
  end

  test "map/2" do
    assert RList.map([1], &to_string(&1)) == Enum.map([1], &to_string(&1))
    assert RList.map(0..3, &to_string(&1)) == Enum.map(0..3, &to_string(&1))
  end

  test "concat/2" do
    list = [1, %{a: 1}, {:b, :c}]
    assert RList.concat(list, 10) == [1, %{a: 1}, {:b, :c}, 10]
    assert RList.concat(list, [10]) == [1, %{a: 1}, {:b, :c}, 10]
    assert RList.concat(list, [[10], [20]]) == [1, %{a: 1}, {:b, :c}, 10, 20]
  end

  describe "count" do
    test "count/1" do
      assert RList.count([1, 2, 3]) == Enum.count([1, 2, 3])
      assert RList.count([]) == Enum.count([])
      assert RList.count([1, true, false, nil]) == Enum.count([1, true, false, nil])
    end

    test "count/2" do
      assert RList.count([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
               Enum.count([1, 2, 3], fn x -> rem(x, 2) == 0 end)

      assert RList.count([], fn x -> rem(x, 2) == 0 end) ==
               Enum.count([], fn x -> rem(x, 2) == 0 end)

      assert RList.count([1, true, false, nil], & &1) == Enum.count([1, true, false, nil], & &1)
    end
  end

  test "keep_if/2" do
    assert RList.keep_if([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)

    assert RList.keep_if([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
  end

  test "delete_if/2" do
    assert RList.delete_if([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.reject([1, 2, 3], fn x -> rem(x, 2) == 0 end)

    assert RList.delete_if([2, 4, 6], fn x -> rem(x, 2) == 0 end) ==
             Enum.reject([2, 4, 6], fn x -> rem(x, 2) == 0 end)

    assert RList.delete_if([1, true, nil, false, 2], & &1) ==
             Enum.reject([1, true, nil, false, 2], & &1)
  end

  test "filter/2" do
    assert RList.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)

    assert RList.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
  end

  test "reject/2" do
    assert RList.reject([1, 2, 3], fn x -> rem(x, 2) == 0 end) ==
             Enum.reject([1, 2, 3], fn x -> rem(x, 2) == 0 end)

    assert RList.reject([2, 4, 6], fn x -> rem(x, 2) == 0 end) ==
             Enum.reject([2, 4, 6], fn x -> rem(x, 2) == 0 end)

    assert RList.reject([1, true, nil, false, 2], & &1) ==
             Enum.reject([1, true, nil, false, 2], & &1)
  end

  test "dig/2" do
    list = [:foo, [:bar, :baz, [:bat, :bam]]]
    assert RList.dig(list, 1) == [:bar, :baz, [:bat, :bam]]
    assert RList.dig(list, 1, [2]) == [:bat, :bam]
    assert RList.dig(list, 1, [2, 0]) == :bat

    assert_raise Protocol.UndefinedError, fn ->
      assert RList.dig(list, 1, [2, 0, 1]) == nil
    end
  end

  # TODO: hard
  # describe "combination/2" do
  #   list = [1, 2, 3, 4]
  #   assert RList.combination(list, 0) |> Enum.to_list() == [[]]
  #   assert RList.combination(list, 1) |> Enum.to_list() == [[1], [2], [3], [4]]
  #   assert RList.combination(list, 2) |> Enum.to_list() == [
  #            [1, 2],
  #            [1, 3],
  #            [1, 4],
  #            [2, 3],
  #            [2, 4],
  #            [3, 4]
  #          ]
  #   assert RList.combination(list, 3) |> Enum.to_list() == [
  #            [1, 2, 3],
  #            [1, 2, 4],
  #            [1, 3, 4],
  #            [2, 3, 4]
  #          ]
  #   assert RList.combination(list, 4) |> Enum.to_list() == [[1, 2, 3, 4]]
  #   assert RList.combination(list, 5) |> Enum.to_list() == []
  # end
end
