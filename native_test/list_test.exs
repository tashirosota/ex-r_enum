defmodule REnum.List.NavtieTest do
  use ExUnit.Case, async: true

  doctest REnum.List

  test "cons cell precedence" do
    assert [1 | REnum.List.flatten([2, 3])] == [1, 2, 3]
  end

  test "optional comma" do
    assert Code.eval_string("[1,]") == {[1], []}
    assert Code.eval_string("[1, 2, 3,]") == {[1, 2, 3], []}
  end

  test "partial application" do
    assert (&[&1, 2]).(1) == [1, 2]
    assert (&[&1, &2]).(1, 2) == [1, 2]
    assert (&[&2, &1]).(2, 1) == [1, 2]
    assert (&[&1 | &2]).(1, 2) == [1 | 2]
    assert (&[&1, &2 | &3]).(1, 2, 3) == [1, 2 | 3]
  end

  test "delete/2" do
    assert REnum.List.delete([:a, :b, :c], :a) == [:b, :c]
    assert REnum.List.delete([:a, :b, :c], :d) == [:a, :b, :c]
    assert REnum.List.delete([:a, :b, :b, :c], :b) == [:a, :b, :c]
    assert REnum.List.delete([], :b) == []
  end

  test "wrap/1" do
    assert REnum.List.wrap([1, 2, 3]) == [1, 2, 3]
    assert REnum.List.wrap(1) == [1]
    assert REnum.List.wrap(nil) == []
  end

  test "flatten/1" do
    assert REnum.List.flatten([1, 2, 3]) == [1, 2, 3]
    assert REnum.List.flatten([1, [2], 3]) == [1, 2, 3]
    assert REnum.List.flatten([[1, [2], 3]]) == [1, 2, 3]

    assert REnum.List.flatten([]) == []
    assert REnum.List.flatten([[]]) == []
    assert REnum.List.flatten([[], [[], []]]) == []
  end

  test "flatten/2" do
    assert REnum.List.flatten([1, 2, 3], [4, 5]) == [1, 2, 3, 4, 5]
    assert REnum.List.flatten([1, [2], 3], [4, 5]) == [1, 2, 3, 4, 5]
    assert REnum.List.flatten([[1, [2], 3]], [4, 5]) == [1, 2, 3, 4, 5]
    assert REnum.List.flatten([1, [], 2], [3, [], 4]) == [1, 2, 3, [], 4]
  end

  test "foldl/3" do
    assert REnum.List.foldl([1, 2, 3], 0, fn x, y -> x + y end) == 6
    assert REnum.List.foldl([1, 2, 3], 10, fn x, y -> x + y end) == 16
    assert REnum.List.foldl([1, 2, 3, 4], 0, fn x, y -> x - y end) == 2
  end

  test "foldr/3" do
    assert REnum.List.foldr([1, 2, 3], 0, fn x, y -> x + y end) == 6
    assert REnum.List.foldr([1, 2, 3], 10, fn x, y -> x + y end) == 16
    assert REnum.List.foldr([1, 2, 3, 4], 0, fn x, y -> x - y end) == -2
  end

  test "duplicate/2" do
    assert REnum.List.duplicate(1, 0) == []
    assert REnum.List.duplicate(1, 3) == [1, 1, 1]
    assert REnum.List.duplicate([1], 1) == [[1]]
  end

  test "first/1" do
    assert REnum.List.first([]) == nil
    assert REnum.List.first([], 1) == 1
    assert REnum.List.first([1]) == 1
    assert REnum.List.first([1, 2, 3]) == 1
  end

  test "last/1" do
    assert REnum.List.last([]) == nil
    assert REnum.List.last([], 1) == 1
    assert REnum.List.last([1]) == 1
    assert REnum.List.last([1, 2, 3]) == 3
  end

  test "zip/1" do
    assert REnum.List.zip([[1, 4], [2, 5], [3, 6]]) == [{1, 2, 3}, {4, 5, 6}]
    assert REnum.List.zip([[1, 4], [2, 5, 0], [3, 6]]) == [{1, 2, 3}, {4, 5, 6}]
    assert REnum.List.zip([[1], [2, 5], [3, 6]]) == [{1, 2, 3}]
    assert REnum.List.zip([[1, 4], [2, 5], []]) == []
  end

  test "keyfind/4" do
    assert REnum.List.keyfind([a: 1, b: 2], :a, 0) == {:a, 1}
    assert REnum.List.keyfind([a: 1, b: 2], 2, 1) == {:b, 2}
    assert REnum.List.keyfind([a: 1, b: 2], :c, 0) == nil
  end

  test "keyreplace/4" do
    assert REnum.List.keyreplace([a: 1, b: 2], :a, 0, {:a, 3}) == [a: 3, b: 2]
    assert REnum.List.keyreplace([a: 1], :b, 0, {:b, 2}) == [a: 1]
  end

  test "keysort/2" do
    assert REnum.List.keysort([a: 4, b: 3, c: 5], 1) == [b: 3, a: 4, c: 5]
    assert REnum.List.keysort([a: 4, c: 1, b: 2], 0) == [a: 4, b: 2, c: 1]
  end

  # test "keysort/3 with stable sorting" do
  #   collection = [
  #     {2, 4},
  #     {1, 5},
  #     {2, 2},
  #     {3, 1},
  #     {4, 3}
  #   ]

  #   # Stable sorting
  #   assert REnum.List.keysort(collection, 0) == [
  #            {1, 5},
  #            {2, 4},
  #            {2, 2},
  #            {3, 1},
  #            {4, 3}
  #          ]

  #   assert REnum.List.keysort(collection, 0) ==
  #            REnum.List.keysort(collection, 0, :asc)

  #   assert REnum.List.keysort(collection, 0, &</2) == [
  #            {1, 5},
  #            {2, 2},
  #            {2, 4},
  #            {3, 1},
  #            {4, 3}
  #          ]

  #   assert REnum.List.keysort(collection, 0, :desc) == [
  #            {4, 3},
  #            {3, 1},
  #            {2, 4},
  #            {2, 2},
  #            {1, 5}
  #          ]
  # end

  # test "keysort/3 with module and stable sorting" do
  #   collection = [
  #     {~D[2010-01-02], 4},
  #     {~D[2010-01-01], 5},
  #     {~D[2010-01-02], 2},
  #     {~D[2010-01-03], 1},
  #     {~D[2010-01-04], 3}
  #   ]

  #   # Stable sorting
  #   assert REnum.List.keysort(collection, 0, Date) == [
  #            {~D[2010-01-01], 5},
  #            {~D[2010-01-02], 4},
  #            {~D[2010-01-02], 2},
  #            {~D[2010-01-03], 1},
  #            {~D[2010-01-04], 3}
  #          ]

  #   assert REnum.List.keysort(collection, 0, Date) ==
  #            REnum.List.keysort(collection, 0, {:asc, Date})

  #   assert REnum.List.keysort(collection, 0, {:desc, Date}) == [
  #            {~D[2010-01-04], 3},
  #            {~D[2010-01-03], 1},
  #            {~D[2010-01-02], 4},
  #            {~D[2010-01-02], 2},
  #            {~D[2010-01-01], 5}
  #          ]
  # end

  test "keystore/4" do
    assert REnum.List.keystore([a: 1, b: 2], :a, 0, {:a, 3}) == [a: 3, b: 2]
    assert REnum.List.keystore([a: 1], :b, 0, {:b, 2}) == [a: 1, b: 2]
  end

  test "keymember?/3" do
    assert REnum.List.keymember?([a: 1, b: 2], :a, 0) == true
    assert REnum.List.keymember?([a: 1, b: 2], 2, 1) == true
    assert REnum.List.keymember?([a: 1, b: 2], :c, 0) == false
  end

  test "keydelete/3" do
    assert REnum.List.keydelete([a: 1, b: 2], :a, 0) == [{:b, 2}]
    assert REnum.List.keydelete([a: 1, b: 2], 2, 1) == [{:a, 1}]
    assert REnum.List.keydelete([a: 1, b: 2], :c, 0) == [{:a, 1}, {:b, 2}]
  end

  test "keytake/3" do
    assert REnum.List.keytake([a: 1, b: 2], :a, 0) == {{:a, 1}, [b: 2]}
    assert REnum.List.keytake([a: 1, b: 2], 2, 1) == {{:b, 2}, [a: 1]}
    assert REnum.List.keytake([a: 1, b: 2], :c, 0) == nil
  end

  test "insert_at/3" do
    assert REnum.List.insert_at([1, 2, 3], 0, 0) == [0, 1, 2, 3]
    assert REnum.List.insert_at([1, 2, 3], 3, 0) == [1, 2, 3, 0]
    assert REnum.List.insert_at([1, 2, 3], 2, 0) == [1, 2, 0, 3]
    assert REnum.List.insert_at([1, 2, 3], 10, 0) == [1, 2, 3, 0]
    assert REnum.List.insert_at([1, 2, 3], -1, 0) == [1, 2, 3, 0]
    assert REnum.List.insert_at([1, 2, 3], -4, 0) == [0, 1, 2, 3]
    assert REnum.List.insert_at([1, 2, 3], -10, 0) == [0, 1, 2, 3]
  end

  test "replace_at/3" do
    assert REnum.List.replace_at([1, 2, 3], 0, 0) == [0, 2, 3]
    assert REnum.List.replace_at([1, 2, 3], 1, 0) == [1, 0, 3]
    assert REnum.List.replace_at([1, 2, 3], 2, 0) == [1, 2, 0]
    assert REnum.List.replace_at([1, 2, 3], 3, 0) == [1, 2, 3]
    assert REnum.List.replace_at([1, 2, 3], -1, 0) == [1, 2, 0]
    assert REnum.List.replace_at([1, 2, 3], -4, 0) == [1, 2, 3]
  end

  test "update_at/3" do
    assert REnum.List.update_at([1, 2, 3], 0, &(&1 + 1)) == [2, 2, 3]
    assert REnum.List.update_at([1, 2, 3], 1, &(&1 + 1)) == [1, 3, 3]
    assert REnum.List.update_at([1, 2, 3], 2, &(&1 + 1)) == [1, 2, 4]
    assert REnum.List.update_at([1, 2, 3], 3, &(&1 + 1)) == [1, 2, 3]
    assert REnum.List.update_at([1, 2, 3], -1, &(&1 + 1)) == [1, 2, 4]
    assert REnum.List.update_at([1, 2, 3], -4, &(&1 + 1)) == [1, 2, 3]
  end

  test "delete_at/2" do
    for index <- [-1, 0, 1] do
      assert REnum.List.delete_at([], index) == []
    end

    assert REnum.List.delete_at([1, 2, 3], 0) == [2, 3]
    assert REnum.List.delete_at([1, 2, 3], 2) == [1, 2]
    assert REnum.List.delete_at([1, 2, 3], 3) == [1, 2, 3]
    assert REnum.List.delete_at([1, 2, 3], -1) == [1, 2]
    assert REnum.List.delete_at([1, 2, 3], -3) == [2, 3]
    assert REnum.List.delete_at([1, 2, 3], -4) == [1, 2, 3]
  end

  test "pop_at/3" do
    for index <- [-1, 0, 1] do
      assert REnum.List.pop_at([], index) == {nil, []}
    end

    assert REnum.List.pop_at([1], 1, 2) == {2, [1]}
    assert REnum.List.pop_at([1, 2, 3], 0) == {1, [2, 3]}
    assert REnum.List.pop_at([1, 2, 3], 2) == {3, [1, 2]}
    assert REnum.List.pop_at([1, 2, 3], 3) == {nil, [1, 2, 3]}
    assert REnum.List.pop_at([1, 2, 3], -1) == {3, [1, 2]}
    assert REnum.List.pop_at([1, 2, 3], -3) == {1, [2, 3]}
    assert REnum.List.pop_at([1, 2, 3], -4) == {nil, [1, 2, 3]}
  end

  describe "starts_with?/2" do
    test "list and prefix are equal" do
      assert REnum.List.starts_with?([], [])
      assert REnum.List.starts_with?([1], [1])
      assert REnum.List.starts_with?([1, 2, 3], [1, 2, 3])
    end

    test "proper lists" do
      refute REnum.List.starts_with?([1], [1, 2])
      assert REnum.List.starts_with?([1, 2, 3], [1, 2])
      refute REnum.List.starts_with?([1, 2, 3], [1, 2, 3, 4])
    end

    test "list is empty" do
      refute REnum.List.starts_with?([], [1])
      refute REnum.List.starts_with?([], [1, 2])
    end

    test "prefix is empty" do
      assert REnum.List.starts_with?([1], [])
      assert REnum.List.starts_with?([1, 2], [])
      assert REnum.List.starts_with?([1, 2, 3], [])
    end

    test "only accepts proper lists" do
      message = "no function clause matching in List.starts_with?/2"

      assert_raise FunctionClauseError, message, fn ->
        REnum.List.starts_with?([1 | 2], [1 | 2])
      end

      message = "no function clause matching in List.starts_with?/2"

      assert_raise FunctionClauseError, message, fn ->
        REnum.List.starts_with?([1, 2], 1)
      end
    end
  end

  test "to_string/1" do
    assert REnum.List.to_string([?æ, ?ß]) == "æß"
    assert REnum.List.to_string([?a, ?b, ?c]) == "abc"
    assert REnum.List.to_string([]) == ""
    assert REnum.List.to_string([[], []]) == ""

    assert_raise UnicodeConversionError, "invalid code point 57343", fn ->
      REnum.List.to_string([0xDFFF])
    end

    assert_raise UnicodeConversionError, "invalid encoding starting at <<216, 0>>", fn ->
      REnum.List.to_string(["a", "b", <<0xD800::size(16)>>])
    end

    assert_raise ArgumentError, ~r"cannot convert the given list to a string", fn ->
      REnum.List.to_string([:a, :b])
    end
  end

  test "to_charlist/1" do
    assert REnum.List.to_charlist([0x00E6, 0x00DF]) == 'æß'
    assert REnum.List.to_charlist([0x0061, "bc"]) == 'abc'
    assert REnum.List.to_charlist([0x0064, "ee", ['p']]) == 'deep'

    assert_raise UnicodeConversionError, "invalid code point 57343", fn ->
      REnum.List.to_charlist([0xDFFF])
    end

    assert_raise UnicodeConversionError, "invalid encoding starting at <<216, 0>>", fn ->
      REnum.List.to_charlist(["a", "b", <<0xD800::size(16)>>])
    end

    assert_raise ArgumentError, ~r"cannot convert the given list to a charlist", fn ->
      REnum.List.to_charlist([:a, :b])
    end
  end

  describe "myers_difference/2" do
    test "follows paper implementation" do
      assert REnum.List.myers_difference([], []) == []
      assert REnum.List.myers_difference([], [1, 2, 3]) == [ins: [1, 2, 3]]
      assert REnum.List.myers_difference([1, 2, 3], []) == [del: [1, 2, 3]]
      assert REnum.List.myers_difference([1, 2, 3], [1, 2, 3]) == [eq: [1, 2, 3]]

      assert REnum.List.myers_difference([1, 2, 3], [1, 4, 2, 3]) == [
               eq: [1],
               ins: [4],
               eq: [2, 3]
             ]

      assert REnum.List.myers_difference([1, 4, 2, 3], [1, 2, 3]) == [
               eq: [1],
               del: [4],
               eq: [2, 3]
             ]

      assert REnum.List.myers_difference([1], [[1]]) == [del: [1], ins: [[1]]]
      assert REnum.List.myers_difference([[1]], [1]) == [del: [[1]], ins: [1]]
    end

    test "rearranges inserts and equals for smaller diffs" do
      assert REnum.List.myers_difference([3, 2, 0, 2], [2, 2, 0, 2]) ==
               [del: [3], ins: [2], eq: [2, 0, 2]]

      assert REnum.List.myers_difference([3, 2, 1, 0, 2], [2, 1, 2, 1, 0, 2]) ==
               [del: [3], ins: [2, 1], eq: [2, 1, 0, 2]]

      assert REnum.List.myers_difference([3, 2, 2, 1, 0, 2], [2, 2, 1, 2, 1, 0, 2]) ==
               [del: [3], eq: [2, 2, 1], ins: [2, 1], eq: [0, 2]]

      assert REnum.List.myers_difference([3, 2, 0, 2], [2, 2, 1, 0, 2]) ==
               [del: [3], eq: [2], ins: [2, 1], eq: [0, 2]]
    end
  end

  test "improper?/1" do
    assert REnum.List.improper?([1 | 2])
    assert REnum.List.improper?([1, 2, 3 | 4])
    refute REnum.List.improper?([])
    refute REnum.List.improper?([1])
    refute REnum.List.improper?([[1]])
    refute REnum.List.improper?([1, 2])
    refute REnum.List.improper?([1, 2, 3])

    assert_raise FunctionClauseError, fn ->
      REnum.List.improper?(%{})
    end
  end

  describe "ascii_printable?/2" do
    test "proper lists without limit" do
      assert REnum.List.ascii_printable?([])
      assert REnum.List.ascii_printable?('abc')
      refute(REnum.List.ascii_printable?('abc' ++ [0]))
      refute REnum.List.ascii_printable?('mañana')

      printable_chars = '\a\b\t\n\v\f\r\e' ++ Enum.to_list(32..126)
      non_printable_chars = '🌢áéíóúźç©¢🂭'

      assert REnum.List.ascii_printable?(printable_chars)

      for char <- printable_chars do
        assert REnum.List.ascii_printable?([char])
      end

      refute REnum.List.ascii_printable?(non_printable_chars)

      for char <- non_printable_chars do
        refute REnum.List.ascii_printable?([char])
      end
    end

    test "proper lists with limit" do
      assert REnum.List.ascii_printable?([], 100)
      assert REnum.List.ascii_printable?('abc' ++ [0], 2)
    end

    test "improper lists" do
      refute REnum.List.ascii_printable?('abc' ++ ?d)
      assert REnum.List.ascii_printable?('abc' ++ ?d, 3)
    end
  end
end
