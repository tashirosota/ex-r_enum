defmodule REnum.Enumerable.SupportTest do
  use ExUnit.Case
  doctest REnum.Enumerable.Support

  test "range?/1" do
    assert REnum.range?([1, 2, 3]) == false
    assert REnum.range?(0..5) == true
    assert REnum.range?(%{a: 1, b: 2, c: 2, d: 4}) == false
  end

  test "is_list_and_not_keyword?/1" do
    assert REnum.is_list_and_not_keyword?(%{a: 1, b: 2}) == false
    assert REnum.is_list_and_not_keyword?(0..5) == false
    assert REnum.is_list_and_not_keyword?(a: 1, b: 2) == false
    assert REnum.is_list_and_not_keyword?([1, 2, 3]) == true
  end

  test "match_function" do
    assert REnum.match_function(1..3).(2) == true
    assert REnum.match_function(1..3).(4) == false
    assert REnum.match_function(3).(3) == true
    assert REnum.match_function(3).(4) == false
    assert REnum.match_function(~r/a/).("abc") == true
    assert REnum.match_function(~r/a/).("bcd") == false
  end
end
