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

  test "exclude?" do
    assert REnum.exclude?([2], 1)
    refute REnum.exclude?([2], 2)
  end

  test "excluding" do
    assert REnum.excluding(1..5, [1, 5]) == [2, 3, 4]
    assert REnum.excluding(1..5, [1, 2]) == [3, 4, 5]
    assert REnum.excluding([[0, 1], [1, 0]], [[1, 0]]) == [[0, 1]]
    assert REnum.excluding(%{foo: 1, bar: 2, baz: 3}, [:bar]) == %{foo: 1, baz: 3}
  end

  test "without" do
    assert REnum.without(1..5, [1, 5]) == [2, 3, 4]
    assert REnum.without(1..5, [1, 2]) == [3, 4, 5]
    assert REnum.without([[0, 1], [1, 0]], [[1, 0]]) == [[0, 1]]
    assert REnum.without(%{foo: 1, bar: 2, baz: 3}, [:bar]) == %{foo: 1, baz: 3}
  end

  test "including" do
    assert REnum.including([1, 2, 3], [4, 5]) == [1, 2, 3, 4, 5]
    assert REnum.including(1..3, 4..6) == [1, 2, 3, 4, 5, 6]

    assert REnum.including(%{foo: 1, bar: 2, baz: 3}, %{hoge: 4, page: 5}) == [
             {:bar, 2},
             {:baz, 3},
             {:foo, 1},
             {:hoge, 4},
             {:page, 5}
           ]
  end

  describe "many?" do
    test "many?/1" do
      refute REnum.many?([])
      refute REnum.many?([1])
      assert REnum.many?([1, 2])
      refute REnum.many?(%{})
      refute REnum.many?(%{a: 1})
      assert REnum.many?(%{a: 1, b: 2})
    end

    test "many?/2" do
      refute REnum.many?([1, 2, 3], &(&1 < 2))
      assert REnum.many?([1, 2, 3], &(&1 < 3))

      refute REnum.many?(["bar", "baz", "foo"], "bar")
      assert REnum.many?(["bar", "baz", "foo"], ~r/a/)
    end
  end

  test "pick/2" do
    payments = [%{dollars: 5, cents: 99}, %{dollars: 10, cents: 0}]
    assert REnum.pick(payments, [:dollars, :cents]) == [5, 99]
    assert REnum.pick(payments, [:dollars]) == 5
    assert REnum.pick(payments, :dollars) == 5

    assert REnum.pick([], :price) == nil
    assert REnum.pick([], [:dollars, :cents]) == nil
  end
end
