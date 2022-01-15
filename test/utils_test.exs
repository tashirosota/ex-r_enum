defmodule REnum.UtilsTest do
  use ExUnit.Case
  doctest REnum.Utils

  test "blank?/1" do
    assert REnum.Utils.blank?(%{})
    assert REnum.Utils.blank?([])
    assert REnum.Utils.blank?(nil)
    assert REnum.Utils.blank?(false)
    assert REnum.Utils.blank?("  ")
    refute REnum.Utils.blank?([1])
    refute REnum.Utils.blank?(true)
    refute REnum.Utils.blank?(1)
    refute REnum.Utils.blank?(" a ")
    refute REnum.Utils.blank?(%{a: [1]})
  end

  test "present?/1" do
    refute REnum.Utils.present?(%{})
    refute REnum.Utils.present?([])
    refute REnum.Utils.present?(nil)
    refute REnum.Utils.present?(false)
    refute REnum.Utils.present?("  ")
    assert REnum.Utils.present?([1])
    assert REnum.Utils.present?(true)
    assert REnum.Utils.present?(1)
    assert REnum.Utils.present?(" a ")
    assert REnum.Utils.present?(%{a: [1]})
  end
end
