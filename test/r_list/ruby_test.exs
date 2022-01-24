defmodule RList.RubyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest RList.Ruby

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

  test "dig/2" do
    list = [:foo, [:bar, :baz, [:bat, :bam]]]
    assert RList.dig(list, 1) == [:bar, :baz, [:bat, :bam]]
    assert RList.dig(list, 1, [2]) == [:bat, :bam]
    assert RList.dig(list, 1, [2, 0]) == :bat

    assert_raise Protocol.UndefinedError, fn ->
      assert RList.dig(list, 1, [2, 0, 1]) == nil
    end
  end

  test "transpose/1" do
    assert RList.transpose([[1, 2, 6], [3, 4, 5]]) == [{1, 3}, {2, 4}, {6, 5}]
    assert RList.transpose([[1, 2, 6, 7], [3, 4, 5]]) == [{1, 3}, {2, 4}, {6, 5}]
    assert RList.transpose([[1, 2, 6], [3, 4, 5, 7]]) == [{1, 3}, {2, 4}, {6, 5}]
  end

  test "prepend/2" do
    assert RList.prepend([]) == RList.shift([])
    assert RList.prepend(~w[-m -q -filename]) == RList.shift(~w[-m -q -filename])
    assert RList.prepend(~w[-m -q -filename], 2) == RList.shift(~w[-m -q -filename], 2)
  end

  describe "combination" do
    list = [1, 2, 3, 4]
    assert RList.combination(list, 0) |> Enum.to_list() == [[]]
    assert RList.combination(list, 1) |> Enum.to_list() == [[1], [2], [3], [4]]

    assert RList.combination(list, 2) |> Enum.to_list() == [
             [1, 2],
             [1, 3],
             [1, 4],
             [2, 3],
             [2, 4],
             [3, 4]
           ]

    assert RList.combination(list, 3) |> Enum.to_list() == [
             [1, 2, 3],
             [1, 2, 4],
             [1, 3, 4],
             [2, 3, 4]
           ]

    assert RList.combination(list, 4) |> Enum.to_list() == [[1, 2, 3, 4]]
    assert RList.combination(list, 5) |> Enum.to_list() == []

    assert capture_io(fn ->
             RList.combination(list, 2, &IO.inspect(&1))
           end) == "[1, 2]\n[1, 3]\n[1, 4]\n[2, 3]\n[2, 4]\n[3, 4]\n"
  end

  describe "repeated_combination" do
    list = [1, 2, 3, 4]

    assert RList.repeated_combination(list, 2) |> Enum.to_list() == [
             [1, 1],
             [1, 2],
             [1, 3],
             [1, 4],
             [2, 2],
             [2, 3],
             [2, 4],
             [3, 3],
             [3, 4],
             [4, 4]
           ]

    assert capture_io(fn ->
             RList.repeated_combination(list, 2, &IO.inspect(&1))
           end) ==
             "[1, 1]\n[1, 2]\n[1, 3]\n[1, 4]\n[2, 2]\n[2, 3]\n[2, 4]\n[3, 3]\n[3, 4]\n[4, 4]\n"
  end
end
