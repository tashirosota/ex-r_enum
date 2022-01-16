defmodule RUtilsTest do
  use ExUnit.Case
  doctest RUtils

  test "blank?/1" do
    assert RUtils.blank?(%{})
    assert RUtils.blank?([])
    assert RUtils.blank?(nil)
    assert RUtils.blank?(false)
    assert RUtils.blank?("  ")
    refute RUtils.blank?([1])
    refute RUtils.blank?(true)
    refute RUtils.blank?(1)
    refute RUtils.blank?(" a ")
    refute RUtils.blank?(%{a: [1]})
  end

  test "present?/1" do
    refute RUtils.present?(%{})
    refute RUtils.present?([])
    refute RUtils.present?(nil)
    refute RUtils.present?(false)
    refute RUtils.present?("  ")
    assert RUtils.present?([1])
    assert RUtils.present?(true)
    assert RUtils.present?(1)
    assert RUtils.present?(" a ")
    assert RUtils.present?(%{a: [1]})
  end
end
