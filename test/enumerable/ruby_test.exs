defmodule REnum.Enumerable.RubyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest REnum.Enumerable.Ruby

  describe "compact/1" do
    test "when list" do
      assert REnum.compact([1, 2, 4]) == [1, 2, 4]
      assert REnum.compact([1, nil, 2, 4]) == [1, 2, 4]
      assert REnum.compact([1, 2, 4, nil]) == [1, 2, 4]
      assert REnum.compact([nil, 1, 2, 4]) == [1, 2, 4]
    end

    test "when map" do
      assert REnum.compact(%{
               :truthy => true,
               false => false,
               nil => nil,
               nil => true,
               :map => %{key: :value}
             }) == %{
               :truthy => true,
               false => false,
               nil => true,
               :map => %{key: :value}
             }
    end
  end

  test "detect/3" do
    assert REnum.detect(2..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.find(2..6, fn x -> rem(x, 2) == 0 end)

    assert REnum.detect(2..6, fn x -> rem(x, 2) == 1 end) ==
             Enum.find(2..6, fn x -> rem(x, 2) == 1 end)

    assert REnum.detect(2..6, fn _ -> false end) == Enum.find(2..6, fn _ -> false end)
    assert REnum.detect(2..6, 0, fn _ -> false end) == Enum.find(2..6, 0, fn _ -> false end)
  end

  test "select/2" do
    assert REnum.select(1..3, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..3, fn x -> rem(x, 2) == 0 end)

    assert REnum.select(1..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..6, fn x -> rem(x, 2) == 0 end)

    assert REnum.select(1..3, &match?(1, &1)) == Enum.filter(1..3, &match?(1, &1))

    assert REnum.select(1..3, &match?(x when x < 3, &1)) ==
             Enum.filter(1..3, &match?(x when x < 3, &1))

    assert REnum.select(1..3, fn _ -> true end) == Enum.filter(1..3, fn _ -> true end)
  end

  test "find_all/2" do
    assert REnum.find_all(1..3, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..3, fn x -> rem(x, 2) == 0 end)

    assert REnum.find_all(1..6, fn x -> rem(x, 2) == 0 end) ==
             Enum.filter(1..6, fn x -> rem(x, 2) == 0 end)

    assert REnum.find_all(1..3, &match?(1, &1)) == Enum.filter(1..3, &match?(1, &1))

    assert REnum.find_all(1..3, &match?(x when x < 3, &1)) ==
             Enum.filter(1..3, &match?(x when x < 3, &1))

    assert REnum.find_all(1..3, fn _ -> true end) == Enum.filter(1..3, fn _ -> true end)
  end

  describe "inject" do
    test "inject/2" do
      assert REnum.inject([1, 2, 3], fn x, acc -> x + acc end) ==
               Enum.reduce([1, 2, 3], fn x, acc -> x + acc end)

      assert_raise Enum.EmptyError, fn ->
        REnum.inject([], fn x, acc -> x + acc end)
      end

      assert_raise Enum.EmptyError, fn ->
        REnum.inject(%{}, fn _, acc -> acc end)
      end
    end

    test "inject/3" do
      assert REnum.inject([], 1, fn x, acc -> x + acc end) ==
               Enum.reduce([], 1, fn x, acc -> x + acc end)

      assert REnum.inject([1, 2, 3], 1, fn x, acc -> x + acc end) ==
               Enum.reduce([1, 2, 3], 1, fn x, acc -> x + acc end)
    end
  end

  test "collect/2" do
    assert REnum.collect([], fn x -> x * 2 end) == Enum.map([], fn x -> x * 2 end)
    assert REnum.collect([1, 2, 3], fn x -> x * 2 end) == Enum.map([1, 2, 3], fn x -> x * 2 end)
  end

  describe "first" do
    test "first/1" do
      assert REnum.first([]) == nil
      assert REnum.first([1, 2, 3]) == 1
      assert REnum.first(%{}) == nil
      assert REnum.first(%{a: 1, b: 2}) == [:a, 1]
    end

    test "first/2" do
      assert REnum.first([], 2) == []
      assert REnum.first([1, 2, 3], 2) == [1, 2]
      assert REnum.first(%{}, 2) == []
      assert REnum.first(%{a: 1, b: 2}, 2) == [[:a, 1], [:b, 2]]
    end
  end

  describe "one?" do
    test "one?/1" do
      assert REnum.one?(1..1) == true
      assert REnum.one?([1, nil, false]) == true
      assert REnum.one?(1..4) == false
      assert REnum.one?(%{foo: 0}) == true
      assert REnum.one?(%{foo: 0, bar: 1}) == false
      assert REnum.one?([]) == false
    end

    test "one?/2 when is_function" do
      assert REnum.one?(1..4, &(&1 < 2)) == true
      assert REnum.one?(1..4, &(&1 < 1)) == false
      assert REnum.one?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 1 end) == true
      assert REnum.one?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 2 end) == false
    end
  end

  describe "none?" do
    test "none?/1" do
      assert REnum.none?(1..4) == false
      assert REnum.none?([nil, false]) == true
      assert REnum.none?(%{foo: 0}) == false
      assert REnum.none?(%{foo: 0, bar: 1}) == false
      assert REnum.none?([]) == true
    end

    test "none?/2 when is_function" do
      assert REnum.none?(1..4, &(&1 < 1)) == true
      assert REnum.none?(1..4, &(&1 < 2)) == false
      assert REnum.none?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 0 end) == true
      assert REnum.none?(%{foo: 0, bar: 1, baz: 2}, fn {_, v} -> v < 1 end) == false
    end
  end

  test "include?/2" do
    assert REnum.include?(1..3, 2)
    refute REnum.include?(1..3, 0)

    assert REnum.include?(1..9//2, 1)
    assert REnum.include?(1..9//2, 9)
    refute REnum.include?(1..9//2, 10)
    refute REnum.include?(1..10//2, 10)
    assert REnum.include?(1..2//2, 1)
    refute REnum.include?(1..2//2, 2)

    assert REnum.include?(-1..-9//-2, -1)
    assert REnum.include?(-1..-9//-2, -9)
    refute REnum.include?(-1..-9//-2, -8)

    refute REnum.include?(1..0//1, 1)
    refute REnum.include?(0..1//-1, 1)
  end

  test "collect_concat/2" do
    assert REnum.collect_concat([], fn x -> [x, x] end) == []
    assert REnum.collect_concat([1, 2, 3], fn x -> [x, x] end) == [1, 1, 2, 2, 3, 3]
    assert REnum.collect_concat([1, 2, 3], fn x -> x..(x + 1) end) == [1, 2, 2, 3, 3, 4]
  end

  test "cycle/3" do
    list = ["a", "b", "c"]

    assert capture_io(fn ->
             REnum.cycle(list, 3, &IO.puts(&1))
           end) == "a\nb\nc\na\nb\nc\na\nb\nc\n"

    assert capture_io(fn ->
             REnum.cycle(list, 0, &IO.puts(&1))
           end) == ""

    assert capture_io(fn ->
             REnum.cycle(list, nil, &IO.puts(&1))
             |> Enum.take(4)
           end) == "a\nb\nc\na\nb\nc\na\nb\nc\na\nb\nc\n"

    map = %{a: 1, b: 2, c: 3}

    assert capture_io(fn ->
             REnum.cycle(map, 3, &IO.inspect(&1))
           end) ==
             "{:a, 1}\n{:b, 2}\n{:c, 3}\n{:a, 1}\n{:b, 2}\n{:c, 3}\n{:a, 1}\n{:b, 2}\n{:c, 3}\n"

    assert capture_io(fn ->
             REnum.cycle(map, 0, &IO.inspect(&1))
           end) == ""

    assert capture_io(fn ->
             REnum.cycle(map, nil, &IO.inspect(&1))
             |> Enum.take(4)
           end) ==
             "{:a, 1}\n{:b, 2}\n{:c, 3}\n{:a, 1}\n{:b, 2}\n{:c, 3}\n{:a, 1}\n{:b, 2}\n{:c, 3}\n{:a, 1}\n{:b, 2}\n{:c, 3}\n"
  end

  test "each_cons/3" do
    assert capture_io(fn ->
             ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
             |> REnum.each_cons(4, &IO.inspect(&1))
           end) ==
             "[\"a\", \"b\", \"c\", \"d\"]\n[\"b\", \"c\", \"d\", \"e\"]\n[\"c\", \"d\", \"e\", \"f\"]\n[\"d\", \"e\", \"f\", \"g\"]\n[\"e\", \"f\", \"g\", \"h\"]\n[\"f\", \"g\", \"h\", \"i\"]\n"

    assert capture_io(fn ->
             %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}
             |> REnum.each_cons(4, &IO.inspect(&1))
           end) ==
             "[a: 1, b: 2, c: 3, d: 4]\n[b: 2, c: 3, d: 4, e: 5]\n[c: 3, d: 4, e: 5, f: 6]\n"

    assert capture_io(fn ->
             1..10
             |> REnum.each_cons(3, &(&1 |> to_string() |> IO.inspect()))
           end) ==
             "<<1, 2, 3>>\n<<2, 3, 4>>\n<<3, 4, 5>>\n<<4, 5, 6>>\n<<5, 6, 7>>\n<<6, 7, 8>>\n\"\\a\\b\\t\"\n\"\\b\\t\\n\"\n"
  end

  test "to_a/1" do
    assert REnum.to_a([1, 2, 3]) == [1, 2, 3]

    assert REnum.to_a(%{:a => 1, 1 => :a, 3 => :b, :b => 5}) == [
             [1, :a],
             [3, :b],
             [:a, 1],
             [:b, 5]
           ]

    assert REnum.to_a(%{a: 1, b: 2, c: 2, d: 4}) == [[:a, 1], [:b, 2], [:c, 2], [:d, 4]]
    assert REnum.to_a(a: 1, b: 2, c: 2, d: 4) == [{:a, 1}, {:b, 2}, {:c, 2}, {:d, 4}]
    range = 0..5
    assert REnum.to_a(range) == [0, 1, 2, 3, 4, 5]
  end

  test "entries/1" do
    assert REnum.entries([1, 2, 3]) == REnum.to_a([1, 2, 3])

    assert REnum.entries(%{:a => 1, 1 => :a, 3 => :b, :b => 5}) ==
             REnum.to_a(%{:a => 1, 1 => :a, 3 => :b, :b => 5})

    assert REnum.entries(%{a: 1, b: 2, c: 2, d: 4}) == REnum.to_a(%{a: 1, b: 2, c: 2, d: 4})
    assert REnum.entries(a: 1, b: 2, c: 2, d: 4) == REnum.to_a(a: 1, b: 2, c: 2, d: 4)
    range = 0..5
    assert REnum.entries(range) == REnum.to_a(range)
  end

  test "range?/1" do
    assert REnum.range?([1, 2, 3]) == false
    assert REnum.range?(0..5) == true
    assert REnum.range?(%{a: 1, b: 2, c: 2, d: 4}) == false
  end

  test "reverse_each/2" do
    assert capture_io(fn ->
             ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
             |> REnum.reverse_each(&IO.inspect(&1))
           end) ==
             "\"i\"\n\"h\"\n\"g\"\n\"f\"\n\"e\"\n\"d\"\n\"c\"\n\"b\"\n\"a\"\n"

    assert capture_io(fn ->
             %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}
             |> REnum.reverse_each(&IO.inspect(&1))
           end) ==
             "{:f, 6}\n{:e, 5}\n{:d, 4}\n{:c, 3}\n{:b, 2}\n{:a, 1}\n"

    assert capture_io(fn ->
             1..10
             |> REnum.reverse_each(&(&1 |> to_string() |> IO.inspect()))
           end) ==
             "\"10\"\n\"9\"\n\"8\"\n\"7\"\n\"6\"\n\"5\"\n\"4\"\n\"3\"\n\"2\"\n\"1\"\n"
  end

  test "each_with_object/3" do
    assert REnum.each_with_object([1, 2, 3], 0, fn n, num -> num + n end) == 6

    assert REnum.each_with_object([1, 2, 3], %{}, fn n, map -> Map.put(map, n, n) end) == %{
             1 => 1,
             2 => 2,
             3 => 3
           }

    assert REnum.each_with_object([1, 2, 3], [], fn n, list -> list ++ [n * 2] end) == [2, 4, 6]
  end

  describe "to_h" do
    test "to_h/1" do
      assert REnum.to_h([[:a, 1], [:b, 2]]) == %{a: 1, b: 2}
      assert REnum.to_h(a: 1, b: 2) == %{a: 1, b: 2}
      assert REnum.to_h(%{a: 1, b: 2}) == %{a: 1, b: 2}
      assert REnum.to_h(MapSet.new(a: 1, b: 2, a: 3)) == %{b: 2, a: 3}
    end

    test "to_h/2" do
      assert REnum.to_h([[:a, 1], [:b, 2]], fn el ->
               {Enum.at(el, 0), Enum.at(el, 1)}
             end) == %{a: 1, b: 2}

      transformer = fn {key, value} -> {key, value * 2} end
      assert REnum.to_h(%{a: 1, b: 2}, transformer) == %{a: 2, b: 4}
      assert REnum.to_h(MapSet.new(a: 1, b: 2, a: 3), transformer) == %{b: 4, a: 6}
    end
  end

  test "is_list_and_not_keyword?/1" do
    assert REnum.is_list_and_not_keyword?(%{a: 1, b: 2}) == false
    assert REnum.is_list_and_not_keyword?(0..5) == false
    assert REnum.is_list_and_not_keyword?(a: 1, b: 2) == false
    assert REnum.is_list_and_not_keyword?([1, 2, 3]) == true
  end
end
