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

  describe "push/2" do
    assert RList.push([1], 2) == [1, 2]
    assert RList.push([1], 1..3) == [1, 1..3]
    assert RList.push([1], [2, 3]) == [1, 2, 3]
    assert RList.push([1], %{a: 1}) == [1, %{a: 1}]
  end

  describe "append/2" do
    assert RList.push([1], 2) == RList.append([1], 2)
    assert RList.push([1], 1..3) == RList.append([1], 1..3)
    assert RList.push([1], [2, 3]) == RList.append([1], [2, 3])
    assert RList.push([1], %{a: 1}) == RList.append([1], %{a: 1})
  end

  describe "assoc/2" do
    a = %{foo: 0}
    b = [1, 15]
    c = [2, 25]
    d = [3, 35]
    list = [a, b, c, d]
    assert RList.assoc(list, 2) == c
    assert RList.assoc(list, 100) == nil
    assert RList.assoc(list, {:foo, 0}) == a
  end

  describe "clear/1" do
    assert RList.clear([1]) == []
    assert RList.clear([]) == []
  end

  describe "at/2" do
    assert RList.at([1], 2) == Enum.at([1], 2)
    assert RList.at(0..3, 2) == Enum.at(0..3, 2)
  end

  describe "map/2" do
    assert RList.map([1], &to_string(&1)) == Enum.map([1], &to_string(&1))
    assert RList.map(0..3, &to_string(&1)) == Enum.map(0..3, &to_string(&1))
  end

  describe "collect/2" do
    assert RList.collect([1], &to_string(&1)) == Enum.map([1], &to_string(&1))
    assert RList.collect(0..3, &to_string(&1)) == Enum.map(0..3, &to_string(&1))
  end

  describe "compact/2" do
    assert RList.compact([1, nil]) == REnum.Ruby.compact([1, nil])
    assert RList.compact([1]) == REnum.Ruby.compact([1])
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
