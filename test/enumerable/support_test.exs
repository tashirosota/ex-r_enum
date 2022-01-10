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
end
