defmodule REnum.RubyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest REnum.Ruby

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
               :map => %{key: :value}
             }) == %{
               :truthy => true,
               false => false,
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
      assert REnum.first(%{a: 1, b: 2}) == {:a, 1}
      assert REnum.first(%{a: 1, b: 2}, 2) == [{:a, 1}, {:b, 2}]
    end

    test "first/2" do
      assert REnum.first([], 2) == []
      assert REnum.first([1, 2, 3], 2) == [1, 2]
      assert REnum.first(%{}, 2) == []
      assert REnum.first(%{a: 1, b: 2}, 2) == [{:a, 1}, {:b, 2}]
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

    test "one?/2" do
      assert REnum.one?(1..4, &(&1 < 2)) == true
      assert REnum.one?(1..4, &(&1 < 1)) == false
      assert REnum.one?(1..4, 1..2) == false
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
    assert REnum.include?(1..3, 2) == REnum.member?(1..3, 2)
    assert REnum.include?(1..3, 0) == REnum.member?(1..3, 0)
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
             {1, :a},
             {3, :b},
             {:a, 1},
             {:b, 5}
           ]

    assert REnum.to_a(%{a: 1, b: 2, c: 2, d: 4}) == [{:a, 1}, {:b, 2}, {:c, 2}, {:d, 4}]
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

  test "list_and_not_keyword?/1" do
    assert REnum.list_and_not_keyword?(%{a: 1, b: 2}) == false
    assert REnum.list_and_not_keyword?(0..5) == false
    assert REnum.list_and_not_keyword?(a: 1, b: 2) == false
    assert REnum.list_and_not_keyword?([1, 2, 3]) == true
  end

  test "chain/2" do
    assert REnum.chain([1, 2, 3], [4, 5]) |> Enum.to_list() == [1, 2, 3, 4, 5]
    assert REnum.chain(1..3, [4, 5]) |> Enum.to_list() == [1, 2, 3, 4, 5]
    assert REnum.chain(1..3, 1..3) |> Enum.to_list() == [1, 2, 3, 1, 2, 3]
    assert REnum.chain(%{a: 1, b: 2}, 1..3) |> Enum.to_list() == [{:a, 1}, {:b, 2}, 1, 2, 3]
  end

  test "each_entry/1" do
    list = ["a", "b", "c"]

    assert capture_io(fn ->
             REnum.each_entry(list, &IO.puts(&1))
           end) == "a\nb\nc\n"

    assert REnum.each_entry(list, &to_string(&1)) == list
  end

  describe "each_slice" do
    test "each_slice/2" do
      list = ["a", "b", "c", "d", "e", "f", "g"]

      assert REnum.each_slice(list, 3) |> Enum.to_list() == [
               ["a", "b", "c"],
               ["d", "e", "f"],
               ["g"]
             ]

      assert REnum.each_slice(list, 0) |> Enum.to_list() == []
      assert REnum.each_slice(list, 8) |> Enum.to_list() == [["a", "b", "c", "d", "e", "f", "g"]]

      map = %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}

      assert REnum.each_slice(map, 4) |> Enum.to_list() == [
               [a: 1, b: 2, c: 3, d: 4],
               [e: 5, f: 6]
             ]
    end

    test "each_slice/3" do
      list = ["a", "b", "c", "d", "e", "f", "g"]

      assert capture_io(fn ->
               REnum.each_slice(list, 3, &IO.inspect(&1))
             end) == "[\"a\", \"b\", \"c\"]\n[\"d\", \"e\", \"f\"]\n[\"g\"]\n"

      assert REnum.each_slice(list, 3, &to_string(&1)) == :ok

      map = %{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6}

      assert capture_io(fn ->
               REnum.each_slice(map, 2, &IO.inspect(&1))
             end) == "[a: 1, b: 2]\n[c: 3, d: 4]\n[e: 5, f: 6]\n"

      assert REnum.each_slice(map, 3, &Enum.to_list(&1)) == :ok
    end
  end

  test "with_index/2" do
    assert REnum.each_with_index([]) == Enum.with_index([])
    assert REnum.each_with_index([1, 2, 3]) == Enum.with_index([1, 2, 3])
    assert REnum.each_with_index([1, 2, 3], 10) == Enum.with_index([1, 2, 3], 10)

    assert REnum.each_with_index([1, 2, 3], fn element, index -> {index, element} end) ==
             Enum.with_index([1, 2, 3], fn element, index -> {index, element} end)
  end

  describe "minmax" do
    test "minmax/1" do
      assert REnum.minmax([1]) == Enum.min_max([1])
      assert REnum.minmax([2, 3, 1]) == Enum.min_max([2, 3, 1])
      assert REnum.minmax([[], :a, {}]) == Enum.min_max([[], :a, {}])

      assert REnum.minmax([1, 1.0]) === Enum.min_max([1, 1.0])
      assert REnum.minmax([1.0, 1]) === Enum.min_max([1.0, 1])

      assert_raise Enum.EmptyError, fn ->
        REnum.min_max([])
      end
    end

    test "minmax/2" do
      assert REnum.minmax([1], fn -> nil end) == Enum.min_max([1], fn -> nil end)
      assert REnum.minmax([2, 3, 1], fn -> nil end) == Enum.min_max([2, 3, 1], fn -> nil end)

      assert REnum.minmax([[], :a, {}], fn -> nil end) ==
               Enum.min_max([[], :a, {}], fn -> nil end)

      assert REnum.min_max([], fn -> {:empty_min, :empty_max} end) ==
               Enum.min_max([], fn -> {:empty_min, :empty_max} end)

      assert REnum.min_max(%{}, fn -> {:empty_min, :empty_max} end) ==
               Enum.min_max(%{}, fn -> {:empty_min, :empty_max} end)
    end
  end

  describe "minmax_by" do
    test "minmax_by/2" do
      assert REnum.minmax_by(["aaa", "a", "aa"], fn x -> String.length(x) end) ==
               Enum.min_max_by(["aaa", "a", "aa"], fn x -> String.length(x) end)

      assert REnum.minmax_by([1, 1.0], & &1) === Enum.min_max_by([1, 1.0], & &1)
      assert REnum.minmax_by([1.0, 1], & &1) === Enum.min_max_by([1.0, 1], & &1)

      assert_raise Enum.EmptyError, fn ->
        REnum.minmax_by([], fn x -> String.length(x) end)
      end
    end

    test "min_max_by/3" do
      assert REnum.minmax_by(["aaa", "a", "aa"], fn x -> String.length(x) end, fn -> nil end) ==
               Enum.min_max_by(["aaa", "a", "aa"], fn x -> String.length(x) end, fn -> nil end)

      assert REnum.minmax_by([], fn x -> String.length(x) end, fn -> {:no_min, :no_max} end) ==
               Enum.min_max_by([], fn x -> String.length(x) end, fn -> {:no_min, :no_max} end)

      assert REnum.minmax_by(%{}, fn x -> String.length(x) end, fn -> {:no_min, :no_max} end) ==
               Enum.min_max_by(%{}, fn x -> String.length(x) end, fn -> {:no_min, :no_max} end)

      assert REnum.minmax_by(["aaa", "a", "aa"], fn x -> String.length(x) end, &>/2) ==
               Enum.min_max_by(["aaa", "a", "aa"], fn x -> String.length(x) end, &>/2)
    end

    test "min_max_by/4" do
      users = [%{id: 1, date: ~D[2019-01-01]}, %{id: 2, date: ~D[2020-01-01]}]

      assert REnum.minmax_by(users, & &1.date, Date) == Enum.min_max_by(users, & &1.date, Date)

      assert REnum.minmax_by(["aaa", "a", "aa"], fn x -> String.length(x) end, &>/2, fn ->
               nil
             end) ==
               Enum.min_max_by(["aaa", "a", "aa"], fn x -> String.length(x) end, &>/2, fn ->
                 nil
               end)

      assert REnum.minmax_by([], fn x -> String.length(x) end, &>/2, fn -> {:no_min, :no_max} end) ==
               Enum.min_max_by([], fn x -> String.length(x) end, &>/2, fn ->
                 {:no_min, :no_max}
               end)

      assert REnum.minmax_by(%{}, fn x -> String.length(x) end, &>/2, fn ->
               {:no_min, :no_max}
             end) ==
               Enum.min_max_by(%{}, fn x -> String.length(x) end, &>/2, fn ->
                 {:no_min, :no_max}
               end)
    end
  end

  test "lazy/1" do
    assert REnum.lazy([1, 2, 3]) |> Enum.to_list() == [1, 2, 3]
    assert REnum.lazy(1..3) |> Enum.to_list() == [1, 2, 3]
    assert REnum.lazy(1..3) |> Enum.to_list() == [1, 2, 3]
    assert REnum.lazy(%{a: 1, b: 2}) |> Enum.to_list() == [{:a, 1}, {:b, 2}]
    assert REnum.lazy([1, 2, 3]).__struct__ == Stream
  end

  test "slice_after/2" do
    assert REnum.slice_after([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], &(rem(&1, 2) == 0)) ==
             [[0], [2], [4], [1, 2], [4], [5, 3, 1, 4], [2]]

    assert REnum.slice_after([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], &(rem(&1, 2) != 0)) ==
             [[0, 2, 4, 1], [2, 4, 5], [3], [1], [4, 2]]

    assert REnum.slice_after(%{a: 1, b: 2, c: 3}, &(&1 == {:b, 2})) ==
             [[a: 1, b: 2], [c: 3]]

    assert REnum.slice_after([a: 1, b: 2, c: 3], &(&1 != {:a, 1})) ==
             [[{:a, 1}, {:b, 2}], [{:c, 3}]]

    assert REnum.slice_after(["1", "2", "3"], ~r/2/) == [["1", "2"], ["3"]]
    assert REnum.slice_after([1, 2, 3], 2..3) == [[1, 2], [3]]
    assert REnum.slice_after([1, 2, 3], 2) == [[1, 2], [3]]
  end

  test "slice_before/2" do
    assert REnum.slice_before([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], &(rem(&1, 2) == 0)) ==
             [[0], [2], [4, 1], [2], [4, 5, 3, 1], [4], [2]]

    assert REnum.slice_before([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], &(rem(&1, 2) != 0)) ==
             [[0, 2, 4], [1, 2, 4], [5], [3], [1, 4, 2]]

    assert REnum.slice_before(%{a: 1, b: 2, c: 3}, &(&1 == {:b, 2})) ==
             [[a: 1], [{:b, 2}, {:c, 3}]]

    assert REnum.slice_before([a: 1, b: 2, c: 3], &(&1 != {:c, 3})) ==
             [[a: 1], [{:b, 2}, {:c, 3}]]

    assert REnum.slice_before(["1", "2", "3"], ~r/2/) == [["1"], ["2", "3"]]
    assert REnum.slice_before([1, 2, 3], 2..2) == [[1], [2, 3]]
    assert REnum.slice_before([1, 2, 3], 2) == [[1], [2, 3]]
  end

  test "slice_when" do
    assert REnum.slice_when([1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21], &(&1 + 1 != &2)) ==
             [[1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21]]

    assert REnum.slice_when(
             ["foo\n", "bar\n", "\n", "baz\n", "qux\n"],
             &(&1 =~ ~r/\A\s*\z/ && &2 =~ ~r/\S/)
           ) ==
             [["foo\n", "bar\n", "\n"], ["baz\n", "qux\n"]]
  end

  describe "grep" do
    test "grep/2" do
      assert REnum.grep([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], 1) ==
               [1, 1]

      assert REnum.grep(1..10, 3..8) ==
               [3, 4, 5, 6, 7, 8]

      assert REnum.grep(["foo", "bar", "car", "moo"], ~r/ar/) ==
               ["bar", "car"]
    end

    test "grep/3" do
      assert REnum.grep([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], 1, &to_string(&1)) ==
               ["1", "1"]

      assert REnum.grep(1..10, 3..8, &to_string(&1)) ==
               ["3", "4", "5", "6", "7", "8"]

      assert REnum.grep(["foo", "bar", "car", "moo"], ~r/ar/, &String.upcase(&1)) ==
               ["BAR", "CAR"]
    end
  end

  describe "grep_v" do
    test "grep_v/2" do
      assert REnum.grep_v([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], 1) ==
               [0, 2, 4, 2, 4, 5, 3, 4, 2]

      assert REnum.grep_v(1..10, 3..8) ==
               [1, 2, 9, 10]

      assert REnum.grep_v(["foo", "bar", "car", "moo"], ~r/ar/) ==
               ["foo", "moo"]
    end

    test "grep_v/3" do
      assert REnum.grep_v([0, 2, 4, 1, 2, 4, 5, 3, 1, 4, 2], 1, &to_string(&1)) ==
               ["0", "2", "4", "2", "4", "5", "3", "4", "2"]

      assert REnum.grep_v(1..10, 3..8, &to_string(&1)) ==
               ["1", "2", "9", "10"]

      assert REnum.grep_v(["foo", "bar", "car", "moo"], ~r/ar/, &String.upcase(&1)) ==
               ["FOO", "MOO"]
    end
  end

  test "tally/1" do
    assert REnum.tally(~w(a c d b c a)) ==
             %{"a" => 2, "c" => 2, "d" => 1, "b" => 1}

    assert REnum.tally([1, 1, 2, 2, 3]) ==
             %{1 => 2, 2 => 2, 3 => 1}

    assert REnum.tally(1..3) ==
             %{1 => 1, 2 => 1, 3 => 1}

    assert REnum.tally(%{a: 1, b: 2, c: 3}) ==
             %{{:a, 1} => 1, {:b, 2} => 1, {:c, 3} => 1}

    assert REnum.tally(a: 1, b: 2, c: 3, c: 3) ==
             %{{:a, 1} => 1, {:b, 2} => 1, {:c, 3} => 2}
  end
end
