defmodule REnum.Enumerable.SupportTest do
  use ExUnit.Case
  doctest REnum.Enumerable.Support
  import ExUnit.CaptureIO

  test "range?/1" do
    assert REnum.range?([1, 2, 3]) == false
    assert REnum.range?(0..5) == true
    assert REnum.range?(%{a: 1, b: 2, c: 2, d: 4}) == false
  end

  test "map_and_not_range?/1" do
    assert REnum.map_and_not_range?(%{})
    assert REnum.map_and_not_range?(%{a: 1})
    refute REnum.map_and_not_range?([])
    refute REnum.map_and_not_range?(1..3)
    assert REnum.map_and_not_range?(%Pdict{})
  end

  test "list_and_not_keyword?/1" do
    assert REnum.list_and_not_keyword?(%{a: 1, b: 2}) == false
    assert REnum.list_and_not_keyword?(0..5) == false
    assert REnum.list_and_not_keyword?(a: 1, b: 2) == false
    assert REnum.list_and_not_keyword?([1, 2, 3]) == true
  end

  test "match_function/1" do
    assert REnum.match_function(1..3).(2) == true
    assert REnum.match_function(1..3).(4) == false
    assert REnum.match_function(3).(3) == true
    assert REnum.match_function(3).(4) == false
    assert REnum.match_function(~r/a/).("abc") == true
    assert REnum.match_function(~r/a/).("bcd") == false
  end

  test "find_index_with_index/2" do
    assert REnum.find_index_with_index(1..3, fn el, _ ->
             el == 2
           end) == 1

    assert capture_io(fn ->
             REnum.find_index_with_index(1..3, fn el, index ->
               IO.inspect(index)
               el == 2
             end)
           end) == "0\n1\n"
  end
end
