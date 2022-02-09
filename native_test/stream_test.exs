defmodule Native.RStreamTest do
  use ExUnit.Case, async: true

  doctest RStream.Native

  test "streams as enumerables" do
    stream = RStream.map([1, 2, 3], &(&1 * 2))

    # Reduce
    assert Enum.map(stream, &(&1 + 1)) == [3, 5, 7]
    # Member
    assert Enum.member?(stream, 4)
    refute Enum.member?(stream, 1)
    # Count
    assert Enum.count(stream) == 3
  end

  test "streams are composable" do
    stream = RStream.map([1, 2, 3], &(&1 * 2))
    assert lazy?(stream)

    stream = RStream.map(stream, &(&1 + 1))
    assert lazy?(stream)

    assert Enum.to_list(stream) == [3, 5, 7]
  end

  test "chunk_every/2, chunk_every/3 and chunk_every/4" do
    assert RStream.chunk_every([1, 2, 3, 4, 5], 2) |> Enum.to_list() == [
             [1, 2],
             [3, 4],
             [5]
           ]

    assert RStream.chunk_every([1, 2, 3, 4, 5], 2, 2, [6]) |> Enum.to_list() ==
             [[1, 2], [3, 4], [5, 6]]

    assert RStream.chunk_every([1, 2, 3, 4, 5, 6], 3, 2, :discard) |> Enum.to_list() ==
             [[1, 2, 3], [3, 4, 5]]

    assert RStream.chunk_every([1, 2, 3, 4, 5, 6], 2, 3, :discard) |> Enum.to_list() ==
             [[1, 2], [4, 5]]

    assert RStream.chunk_every([1, 2, 3, 4, 5, 6], 3, 2, []) |> Enum.to_list() ==
             [[1, 2, 3], [3, 4, 5], [5, 6]]

    assert RStream.chunk_every([1, 2, 3, 4, 5, 6], 3, 3, []) |> Enum.to_list() ==
             [[1, 2, 3], [4, 5, 6]]

    assert RStream.chunk_every([1, 2, 3, 4, 5], 4, 4, 6..10) |> Enum.to_list() ==
             [[1, 2, 3, 4], [5, 6, 7, 8]]
  end

  test "chunk_every/4 is zippable" do
    stream = RStream.chunk_every([1, 2, 3, 4, 5, 6], 3, 2, [])
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "chunk_every/4 is haltable" do
    assert 1..10
           |> RStream.take(6)
           |> RStream.chunk_every(4, 4, [7, 8])
           |> Enum.to_list() ==
             [[1, 2, 3, 4], [5, 6, 7, 8]]

    assert 1..10
           |> RStream.take(6)
           |> RStream.chunk_every(4, 4, [7, 8])
           |> RStream.take(3)
           |> Enum.to_list() == [[1, 2, 3, 4], [5, 6, 7, 8]]

    assert 1..10
           |> RStream.take(6)
           |> RStream.chunk_every(4, 4, [7, 8])
           |> RStream.take(2)
           |> Enum.to_list() == [[1, 2, 3, 4], [5, 6, 7, 8]]

    assert 1..10
           |> RStream.take(6)
           |> RStream.chunk_every(4, 4, [7, 8])
           |> RStream.take(1)
           |> Enum.to_list() == [[1, 2, 3, 4]]

    assert 1..6
           |> RStream.take(6)
           |> RStream.chunk_every(4, 4, [7, 8])
           |> Enum.to_list() ==
             [[1, 2, 3, 4], [5, 6, 7, 8]]
  end

  test "chunk_by/2" do
    stream = RStream.chunk_by([1, 2, 2, 3, 4, 4, 6, 7, 7], &(rem(&1, 2) == 1))

    assert lazy?(stream)
    assert Enum.to_list(stream) == [[1], [2, 2], [3], [4, 4, 6], [7, 7]]
    assert stream |> RStream.take(3) |> Enum.to_list() == [[1], [2, 2], [3]]
    assert 1..10 |> RStream.chunk_every(2) |> Enum.take(2) == [[1, 2], [3, 4]]
  end

  test "chunk_by/2 is zippable" do
    stream = RStream.chunk_by([1, 2, 2, 3], &(rem(&1, 2) == 1))
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "chunk_while/4" do
    chunk_fun = fn i, acc ->
      cond do
        i > 10 -> {:halt, acc}
        rem(i, 2) == 0 -> {:cont, Enum.reverse([i | acc]), []}
        true -> {:cont, [i | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end

    assert RStream.chunk_while([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [], chunk_fun, after_fun)
           |> Enum.to_list() == [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

    assert RStream.chunk_while(0..9, [], chunk_fun, after_fun) |> Enum.to_list() ==
             [[0], [1, 2], [3, 4], [5, 6], [7, 8], [9]]

    assert RStream.chunk_while(0..10, [], chunk_fun, after_fun) |> Enum.to_list() ==
             [[0], [1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

    assert RStream.chunk_while(0..11, [], chunk_fun, after_fun) |> Enum.to_list() ==
             [[0], [1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

    assert RStream.chunk_while([5, 7, 9, 11], [], chunk_fun, after_fun) |> Enum.to_list() ==
             [[5, 7, 9]]
  end

  test "chunk_while/4 with inner halt" do
    chunk_fun = fn
      i, [] ->
        {:cont, [i]}

      i, chunk ->
        if rem(i, 2) == 0 do
          {:cont, Enum.reverse(chunk), [i]}
        else
          {:cont, [i | chunk]}
        end
    end

    after_fun = fn
      [] -> {:cont, []}
      chunk -> {:cont, Enum.reverse(chunk), []}
    end

    assert RStream.chunk_while([1, 2, 3, 4, 5], [], chunk_fun, after_fun) |> Enum.at(0) ==
             [1]
  end

  test "concat/1" do
    stream = RStream.concat([1..3, [], [4, 5, 6], [], 7..9])
    assert is_function(stream)

    assert Enum.to_list(stream) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
    assert Enum.take(stream, 5) == [1, 2, 3, 4, 5]

    stream = RStream.concat([1..3, [4, 5, 6], RStream.cycle(7..100)])
    assert is_function(stream)

    assert Enum.take(stream, 13) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
  end

  test "concat/2" do
    stream = RStream.concat(1..3, 4..6)
    assert is_function(stream)

    assert RStream.cycle(stream) |> Enum.take(16) ==
             [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4]

    stream = RStream.concat(1..3, [])
    assert is_function(stream)
    assert RStream.cycle(stream) |> Enum.take(5) == [1, 2, 3, 1, 2]

    stream = RStream.concat(1..6, RStream.cycle(7..9))
    assert is_function(stream)

    assert RStream.drop(stream, 3) |> Enum.take(13) == [
             4,
             5,
             6,
             7,
             8,
             9,
             7,
             8,
             9,
             7,
             8,
             9,
             7
           ]

    stream = RStream.concat(RStream.cycle(1..3), RStream.cycle(4..6))
    assert is_function(stream)
    assert Enum.take(stream, 13) == [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1]
  end

  test "concat/2 is zippable" do
    stream = 1..2 |> RStream.take(2) |> RStream.concat(3..4)
    assert Enum.zip(1..4, [1, 2, 3, 4]) == Enum.zip(1..4, stream)
  end

  test "concat/2 does not intercept wrapped lazy enumeration" do
    # concat returns a lazy enumeration that does not halt
    assert RStream.concat([[0], RStream.map([1, 2, 3], & &1), [4]])
           |> RStream.take_while(fn x -> x <= 4 end)
           |> Enum.to_list() == [0, 1, 2, 3, 4]

    # concat returns a lazy enumeration that does halts
    assert RStream.concat([[0], RStream.take_while(1..6, &(&1 <= 3)), [4]])
           |> RStream.take_while(fn x -> x <= 4 end)
           |> Enum.to_list() == [0, 1, 2, 3, 4]
  end

  test "cycle/1" do
    stream = RStream.cycle([1, 2, 3])
    assert is_function(stream)

    assert_raise ArgumentError, "cannot cycle over an empty enumerable", fn ->
      RStream.cycle([])
    end

    assert_raise ArgumentError, "cannot cycle over an empty enumerable", fn ->
      RStream.cycle(%{}) |> Enum.to_list()
    end

    assert RStream.cycle([1, 2, 3]) |> RStream.take(5) |> Enum.to_list() == [
             1,
             2,
             3,
             1,
             2
           ]

    assert Enum.take(stream, 5) == [1, 2, 3, 1, 2]
  end

  test "cycle/1 is zippable" do
    stream = RStream.cycle([1, 2, 3])
    assert Enum.zip(1..6, [1, 2, 3, 1, 2, 3]) == Enum.zip(1..6, stream)
  end

  test "cycle/1 with inner stream" do
    assert [1, 2, 3] |> RStream.take(2) |> RStream.cycle() |> Enum.take(4) == [
             1,
             2,
             1,
             2
           ]
  end

  test "cycle/1 with cycle/1 with cycle/1" do
    assert [1]
           |> RStream.cycle()
           |> RStream.cycle()
           |> RStream.cycle()
           |> Enum.take(5) ==
             [1, 1, 1, 1, 1]
  end

  test "dedup/1 is lazy" do
    assert lazy?(RStream.dedup([1, 2, 3]))
  end

  test "dedup/1" do
    assert RStream.dedup([1, 1, 2, 1, 1, 2, 1]) |> Enum.to_list() == [1, 2, 1, 2, 1]
    assert RStream.dedup([2, 1, 1, 2, 1]) |> Enum.to_list() == [2, 1, 2, 1]
    assert RStream.dedup([1, 2, 3, 4]) |> Enum.to_list() == [1, 2, 3, 4]
    assert RStream.dedup([1, 1.0, 2.0, 2]) |> Enum.to_list() == [1, 1.0, 2.0, 2]
    assert RStream.dedup([]) |> Enum.to_list() == []

    assert RStream.dedup([nil, nil, true, {:value, true}]) |> Enum.to_list() ==
             [nil, true, {:value, true}]

    assert RStream.dedup([nil]) |> Enum.to_list() == [nil]
  end

  test "dedup_by/2" do
    assert RStream.dedup_by([{1, :x}, {2, :y}, {2, :z}, {1, :x}], fn {x, _} -> x end)
           |> Enum.to_list() == [{1, :x}, {2, :y}, {1, :x}]
  end

  test "drop/2" do
    stream = RStream.drop(1..10, 5)
    assert lazy?(stream)
    assert Enum.to_list(stream) == [6, 7, 8, 9, 10]

    assert Enum.to_list(RStream.drop(1..5, 0)) == [1, 2, 3, 4, 5]
    assert Enum.to_list(RStream.drop(1..3, 5)) == []

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.drop(nats, 2) |> Enum.take(5) == [3, 4, 5, 6, 7]
  end

  test "drop/2 with negative count" do
    stream = RStream.drop(1..10, -5)
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 3, 4, 5]

    stream = RStream.drop(1..10, -5)
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "drop/2 with negative count stream entries" do
    par = self()

    pid =
      spawn_link(fn ->
        Enum.each(RStream.drop(&inbox_stream/2, -3), fn x -> send(par, {:stream, x}) end)
      end)

    send(pid, {:stream, 1})
    send(pid, {:stream, 2})
    send(pid, {:stream, 3})
    refute_receive {:stream, 1}

    send(pid, {:stream, 4})
    assert_receive {:stream, 1}

    send(pid, {:stream, 5})
    assert_receive {:stream, 2}
    refute_receive {:stream, 3}
  end

  test "drop_every/2" do
    assert 1..10
           |> RStream.drop_every(2)
           |> Enum.to_list() == [2, 4, 6, 8, 10]

    assert 1..10
           |> RStream.drop_every(3)
           |> Enum.to_list() == [2, 3, 5, 6, 8, 9]

    assert 1..10
           |> RStream.drop(2)
           |> RStream.drop_every(2)
           |> RStream.drop(1)
           |> Enum.to_list() == [6, 8, 10]

    assert 1..10
           |> RStream.drop_every(0)
           |> Enum.to_list() == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    assert []
           |> RStream.drop_every(10)
           |> Enum.to_list() == []
  end

  test "drop_every/2 without non-negative integer" do
    assert_raise FunctionClauseError, fn ->
      RStream.drop_every(1..10, -1)
    end

    assert_raise FunctionClauseError, fn ->
      RStream.drop_every(1..10, 3.33)
    end
  end

  test "drop_while/2" do
    stream = RStream.drop_while(1..10, &(&1 <= 5))
    assert lazy?(stream)
    assert Enum.to_list(stream) == [6, 7, 8, 9, 10]

    assert Enum.to_list(RStream.drop_while(1..5, &(&1 <= 0))) == [1, 2, 3, 4, 5]
    assert Enum.to_list(RStream.drop_while(1..3, &(&1 <= 5))) == []

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.drop_while(nats, &(&1 <= 5)) |> Enum.take(5) == [6, 7, 8, 9, 10]
  end

  test "each/2" do
    Process.put(:stream_each, [])

    stream =
      RStream.each([1, 2, 3], fn x ->
        Process.put(:stream_each, [x | Process.get(:stream_each)])
      end)

    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 3]
    assert Process.get(:stream_each) == [3, 2, 1]
  end

  test "filter/2" do
    stream = RStream.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    assert lazy?(stream)
    assert Enum.to_list(stream) == [2]

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.filter(nats, &(rem(&1, 2) == 0)) |> Enum.take(5) == [2, 4, 6, 8, 10]
  end

  test "flat_map/2" do
    stream = RStream.flat_map([1, 2, 3], &[&1, &1 * 2])
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 2, 4, 3, 6]

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.flat_map(nats, &[&1, &1 * 2]) |> Enum.take(6) == [1, 2, 2, 4, 3, 6]
  end

  test "flat_map/2 does not intercept wrapped lazy enumeration" do
    # flat_map returns a lazy enumeration that does not halt
    assert [1, 2, 3, -1, -2]
           |> RStream.flat_map(fn x -> RStream.map([x, x + 1], & &1) end)
           |> RStream.take_while(fn x -> x >= 0 end)
           |> Enum.to_list() == [1, 2, 2, 3, 3, 4]

    # flat_map returns a lazy enumeration that does halts
    assert [1, 2, 3, -1, -2]
           |> RStream.flat_map(fn x ->
             RStream.take_while([x, x + 1, x + 2], &(&1 <= x + 1))
           end)
           |> RStream.take_while(fn x -> x >= 0 end)
           |> Enum.to_list() == [1, 2, 2, 3, 3, 4]

    # flat_map returns a lazy enumeration that does halts wrapped in an enumerable
    assert [1, 2, 3, -1, -2]
           |> RStream.flat_map(fn x ->
             RStream.concat([x], RStream.take_while([x + 1, x + 2], &(&1 <= x + 1)))
           end)
           |> RStream.take_while(fn x -> x >= 0 end)
           |> Enum.to_list() == [1, 2, 2, 3, 3, 4]
  end

  test "flat_map/2 is zippable" do
    stream =
      [1, 2, 3, -1, -2]
      |> RStream.flat_map(fn x -> RStream.map([x, x + 1], & &1) end)
      |> RStream.take_while(fn x -> x >= 0 end)

    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "flat_map/2 does not leave inner stream suspended" do
    stream =
      RStream.flat_map([1, 2, 3], fn i ->
        RStream.resource(fn -> i end, fn acc -> {[acc], acc + 1} end, fn _ ->
          Process.put(:stream_flat_map, true)
        end)
      end)

    Process.put(:stream_flat_map, false)
    assert stream |> Enum.take(3) == [1, 2, 3]
    assert Process.get(:stream_flat_map)
  end

  test "flat_map/2 does not leave outer stream suspended" do
    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_flat_map, true)
      end)

    stream = RStream.flat_map(stream, fn i -> [i, i + 1, i + 2] end)

    Process.put(:stream_flat_map, false)
    assert stream |> Enum.take(3) == [1, 2, 3]
    assert Process.get(:stream_flat_map)
  end

  test "flat_map/2 closes on error" do
    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_flat_map, true)
      end)

    stream = RStream.flat_map(stream, fn _ -> throw(:error) end)

    Process.put(:stream_flat_map, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_flat_map)
  end

  test "flat_map/2 with inner flat_map/2" do
    stream =
      RStream.flat_map(1..5, fn x ->
        RStream.flat_map([x], fn x ->
          x..(x * x)
        end)
        |> RStream.map(&(&1 * 1))
      end)

    assert Enum.take(stream, 5) == [1, 2, 3, 4, 3]
  end

  test "flat_map/2 properly halts both inner and outer stream when inner stream is halted" do
    # Fixes a bug that, when the inner stream was done,
    # sending it a halt would cause it to return the
    # inner stream was halted, forcing flat_map to get
    # the next value from the outer stream, evaluate it,
    # get another inner stream, just to halt it.
    # 2 should never be used
    assert [1, 2]
           |> RStream.flat_map(fn 1 -> RStream.repeatedly(fn -> 1 end) end)
           |> RStream.flat_map(fn 1 -> RStream.repeatedly(fn -> 1 end) end)
           |> Enum.take(1) == [1]
  end

  test "interval/1" do
    stream = RStream.interval(10)
    {time_us, value} = :timer.tc(fn -> Enum.take(stream, 5) end)

    assert value == [0, 1, 2, 3, 4]
    assert time_us >= 50000
  end

  test "interval/1 with infinity" do
    stream = RStream.interval(:infinity)
    spawn(RStream, :run, [stream])
  end

  test "into/2 and run/1" do
    Process.put(:stream_cont, [])
    Process.put(:stream_done, false)
    Process.put(:stream_halt, false)

    stream = RStream.into([1, 2, 3], %Pdict{})

    assert lazy?(stream)
    assert RStream.run(stream) == :ok
    assert Process.get(:stream_cont) == [3, 2, 1]
    assert Process.get(:stream_done)
    refute Process.get(:stream_halt)

    stream = RStream.into(fn _, _ -> raise "error" end, %Pdict{})
    catch_error(RStream.run(stream))
    assert Process.get(:stream_halt)
  end

  test "into/3" do
    Process.put(:stream_cont, [])
    Process.put(:stream_done, false)
    Process.put(:stream_halt, false)

    stream = RStream.into([1, 2, 3], %Pdict{}, fn x -> x * 2 end)

    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 3]
    assert Process.get(:stream_cont) == [6, 4, 2]
    assert Process.get(:stream_done)
    refute Process.get(:stream_halt)
  end

  test "into/2 with halting" do
    Process.put(:stream_cont, [])
    Process.put(:stream_done, false)
    Process.put(:stream_halt, false)

    stream = RStream.into([1, 2, 3], %Pdict{})

    assert lazy?(stream)
    assert Enum.take(stream, 1) == [1]
    assert Process.get(:stream_cont) == [1]
    assert Process.get(:stream_done)
    refute Process.get(:stream_halt)
  end

  test "transform/3" do
    stream = RStream.transform([1, 2, 3], 0, &{[&1, &2], &1 + &2})
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 0, 2, 1, 3, 3]

    nats = RStream.iterate(1, &(&1 + 1))

    assert RStream.transform(nats, 0, &{[&1, &2], &1 + &2}) |> Enum.take(6) == [
             1,
             0,
             2,
             1,
             3,
             3
           ]
  end

  test "transform/3 with early halt" do
    stream =
      fn -> throw(:error) end
      |> RStream.repeatedly()
      |> RStream.transform(nil, &{[&1, &2], &1})

    assert {:halted, nil} = Enumerable.reduce(stream, {:halt, nil}, fn _, _ -> throw(:error) end)
  end

  test "transform/3 with early suspend" do
    stream =
      RStream.repeatedly(fn -> throw(:error) end)
      |> RStream.transform(nil, &{[&1, &2], &1})

    assert {:suspended, nil, _} =
             Enumerable.reduce(stream, {:suspend, nil}, fn _, _ -> throw(:error) end)
  end

  test "transform/3 with halt" do
    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_transform, true)
      end)

    stream =
      RStream.transform(stream, 0, fn i, acc ->
        if acc < 3, do: {[i], acc + 1}, else: {:halt, acc}
      end)

    Process.put(:stream_transform, false)
    assert Enum.to_list(stream) == [1, 2, 3]
    assert Process.get(:stream_transform)
  end

  test "transform/3 (via flat_map) handles multiple returns from suspension" do
    assert [false]
           |> RStream.take(1)
           |> RStream.concat([true])
           |> RStream.flat_map(&[&1])
           |> Enum.to_list() == [false, true]
  end

  test "iterate/2" do
    stream = RStream.iterate(0, &(&1 + 2))
    assert Enum.take(stream, 5) == [0, 2, 4, 6, 8]
    stream = RStream.iterate(5, &(&1 + 2))
    assert Enum.take(stream, 5) == [5, 7, 9, 11, 13]

    # Only calculate values if needed
    stream = RStream.iterate("HELLO", &raise/1)
    assert Enum.take(stream, 1) == ["HELLO"]
  end

  test "map/2" do
    stream = RStream.map([1, 2, 3], &(&1 * 2))
    assert lazy?(stream)
    assert Enum.to_list(stream) == [2, 4, 6]

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.map(nats, &(&1 * 2)) |> Enum.take(5) == [2, 4, 6, 8, 10]

    assert RStream.map(nats, &(&1 - 2)) |> RStream.map(&(&1 * 2)) |> Enum.take(3) ==
             [-2, 0, 2]
  end

  test "map_every/3" do
    assert 1..10
           |> RStream.map_every(2, &(&1 * 2))
           |> Enum.to_list() == [2, 2, 6, 4, 10, 6, 14, 8, 18, 10]

    assert 1..10
           |> RStream.map_every(3, &(&1 * 2))
           |> Enum.to_list() == [2, 2, 3, 8, 5, 6, 14, 8, 9, 20]

    assert 1..10
           |> RStream.drop(2)
           |> RStream.map_every(2, &(&1 * 2))
           |> RStream.drop(1)
           |> Enum.to_list() == [4, 10, 6, 14, 8, 18, 10]

    assert 1..5
           |> RStream.map_every(0, &(&1 * 2))
           |> Enum.to_list() == [1, 2, 3, 4, 5]

    assert []
           |> RStream.map_every(10, &(&1 * 2))
           |> Enum.to_list() == []

    assert_raise FunctionClauseError, fn ->
      RStream.map_every(1..10, -1, &(&1 * 2))
    end

    assert_raise FunctionClauseError, fn ->
      RStream.map_every(1..10, 3.33, &(&1 * 2))
    end
  end

  test "reject/2" do
    stream = RStream.reject([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 3]

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.reject(nats, &(rem(&1, 2) == 0)) |> Enum.take(5) == [1, 3, 5, 7, 9]
  end

  test "repeatedly/1" do
    stream = RStream.repeatedly(fn -> 1 end)
    assert Enum.take(stream, 5) == [1, 1, 1, 1, 1]
    stream = RStream.repeatedly(&:rand.uniform/0)
    [r1, r2] = Enum.take(stream, 2)
    assert r1 != r2
  end

  test "resource/3 closes on outer errors" do
    stream =
      RStream.resource(
        fn -> 1 end,
        fn
          2 -> throw(:error)
          acc -> {[acc], acc + 1}
        end,
        fn 2 -> Process.put(:stream_resource, true) end
      )

    Process.put(:stream_resource, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource)
  end

  test "resource/3 closes with correct accumulator on outer errors with inner single-element list" do
    stream =
      RStream.resource(
        fn -> :start end,
        fn _ -> {[:error], :end} end,
        fn acc -> Process.put(:stream_resource, acc) end
      )
      |> RStream.map(fn :error -> throw(:error) end)

    Process.put(:stream_resource, nil)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource) == :end
  end

  test "resource/3 closes with correct accumulator on outer errors with inner list" do
    stream =
      RStream.resource(
        fn -> :start end,
        fn _ -> {[:ok, :error], :end} end,
        fn acc -> Process.put(:stream_resource, acc) end
      )
      |> RStream.map(fn acc -> if acc == :error, do: throw(:error), else: acc end)

    Process.put(:stream_resource, nil)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource) == :end
  end

  test "resource/3 closes with correct accumulator on outer errors with inner enum" do
    stream =
      RStream.resource(
        fn -> 1 end,
        fn acc -> {acc..(acc + 2), acc + 1} end,
        fn acc -> Process.put(:stream_resource, acc) end
      )
      |> RStream.map(fn x -> if x > 2, do: throw(:error), else: x end)

    Process.put(:stream_resource, nil)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource) == 2
  end

  test "resource/3 is zippable" do
    transform_fun = fn
      10 -> {:halt, 10}
      acc -> {[acc], acc + 1}
    end

    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_resource, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_resource)
  end

  test "resource/3 returning inner empty list" do
    transform_fun = fn acc -> if rem(acc, 2) == 0, do: {[], acc + 1}, else: {[acc], acc + 1} end
    stream = RStream.resource(fn -> 1 end, transform_fun, fn _ -> :ok end)

    assert Enum.take(stream, 5) == [1, 3, 5, 7, 9]
  end

  test "resource/3 halts with inner list" do
    transform_fun = fn acc -> {[acc, acc + 1, acc + 2], acc + 1} end
    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    Process.put(:stream_resource, false)
    assert Enum.take(stream, 5) == [1, 2, 3, 2, 3]
    assert Process.get(:stream_resource)
  end

  test "resource/3 closes on errors with inner list" do
    transform_fun = fn acc -> {[acc, acc + 1, acc + 2], acc + 1} end
    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    Process.put(:stream_resource, false)
    stream = RStream.map(stream, fn x -> if x > 2, do: throw(:error), else: x end)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource)
  end

  test "resource/3 is zippable with inner list" do
    transform_fun = fn
      10 -> {:halt, 10}
      acc -> {[acc, acc + 1, acc + 2], acc + 1}
    end

    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_resource, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_resource)
  end

  test "resource/3 halts with inner enum" do
    transform_fun = fn acc -> {acc..(acc + 2), acc + 1} end
    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    Process.put(:stream_resource, false)
    assert Enum.take(stream, 5) == [1, 2, 3, 2, 3]
    assert Process.get(:stream_resource)
  end

  test "resource/3 closes on errors with inner enum" do
    transform_fun = fn acc -> {acc..(acc + 2), acc + 1} end
    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    Process.put(:stream_resource, false)
    stream = RStream.map(stream, fn x -> if x > 2, do: throw(:error), else: x end)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_resource)
  end

  test "resource/3 is zippable with inner enum" do
    transform_fun = fn
      10 -> {:halt, 10}
      acc -> {acc..(acc + 2), acc + 1}
    end

    after_fun = fn _ -> Process.put(:stream_resource, true) end
    stream = RStream.resource(fn -> 1 end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_resource, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_resource)
  end

  test "transform/4" do
    transform_fun = fn x, acc -> {[x, x + acc], x} end
    after_fun = fn 10 -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..10, fn -> 0 end, transform_fun, after_fun)
    Process.put(:stream_transform, false)

    assert Enum.to_list(stream) ==
             [1, 1, 2, 3, 3, 5, 4, 7, 5, 9, 6, 11, 7, 13, 8, 15, 9, 17, 10, 19]

    assert Process.get(:stream_transform)
  end

  test "transform/4 with early halt" do
    after_fun = fn nil -> Process.put(:stream_transform, true) end

    stream =
      fn -> throw(:error) end
      |> RStream.repeatedly()
      |> RStream.transform(fn -> nil end, &{[&1, &2], &1}, after_fun)

    Process.put(:stream_transform, false)
    assert {:halted, nil} = Enumerable.reduce(stream, {:halt, nil}, fn _, _ -> throw(:error) end)
    assert Process.get(:stream_transform)
  end

  test "transform/4 with early suspend" do
    after_fun = fn nil -> Process.put(:stream_transform, true) end

    stream =
      fn -> throw(:error) end
      |> RStream.repeatedly()
      |> RStream.transform(fn -> nil end, &{[&1, &2], &1}, after_fun)

    refute Process.get(:stream_transform)

    assert {:suspended, nil, _} =
             Enumerable.reduce(stream, {:suspend, nil}, fn _, _ -> throw(:error) end)
  end

  test "transform/4 closes on outer errors" do
    transform_fun = fn
      3, _ -> throw(:error)
      x, acc -> {[x + acc], x}
    end

    after_fun = fn 2 -> Process.put(:stream_transform, true) end

    stream = RStream.transform(1..10, fn -> 0 end, transform_fun, after_fun)

    Process.put(:stream_transform, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_transform)
  end

  test "transform/4 closes on nested errors" do
    transform_fun = fn
      3, _ -> throw(:error)
      x, acc -> {[x + acc], x}
    end

    after_fun = fn _ -> Process.put(:stream_transform_inner, true) end
    outer_after_fun = fn 0 -> Process.put(:stream_transform_outer, true) end

    stream =
      1..10
      |> RStream.transform(fn -> 0 end, transform_fun, after_fun)
      |> RStream.transform(fn -> 0 end, fn x, acc -> {[x], acc} end, outer_after_fun)

    Process.put(:stream_transform_inner, false)
    Process.put(:stream_transform_outer, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_transform_inner)
    assert Process.get(:stream_transform_outer)
  end

  test "transform/4 is zippable" do
    transform_fun = fn
      10, acc -> {:halt, acc}
      x, acc -> {[x + acc], x}
    end

    after_fun = fn 9 -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..20, fn -> 0 end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_transform, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_transform)
  end

  test "transform/4 halts with inner list" do
    transform_fun = fn x, acc -> {[x, x + 1, x + 2], acc} end
    after_fun = fn :acc -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..10, fn -> :acc end, transform_fun, after_fun)

    Process.put(:stream_transform, false)
    assert Enum.take(stream, 5) == [1, 2, 3, 2, 3]
    assert Process.get(:stream_transform)
  end

  test "transform/4 closes on errors with inner list" do
    transform_fun = fn x, acc -> {[x, x + 1, x + 2], acc} end
    after_fun = fn :acc -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..10, fn -> :acc end, transform_fun, after_fun)

    Process.put(:stream_transform, false)
    stream = RStream.map(stream, fn x -> if x > 2, do: throw(:error), else: x end)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_transform)
  end

  test "transform/4 is zippable with inner list" do
    transform_fun = fn
      10, acc -> {:halt, acc}
      x, acc -> {[x, x + 1, x + 2], acc}
    end

    after_fun = fn :inner -> Process.put(:stream_transform, true) end

    stream = RStream.transform(1..20, fn -> :inner end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_transform, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_transform)
  end

  test "transform/4 halts with inner enum" do
    transform_fun = fn x, acc -> {x..(x + 2), acc} end
    after_fun = fn :acc -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..10, fn -> :acc end, transform_fun, after_fun)

    Process.put(:stream_transform, false)
    assert Enum.take(stream, 5) == [1, 2, 3, 2, 3]
    assert Process.get(:stream_transform)
  end

  test "transform/4 closes on errors with inner enum" do
    transform_fun = fn x, acc -> {x..(x + 2), acc} end
    after_fun = fn :acc -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..10, fn -> :acc end, transform_fun, after_fun)

    Process.put(:stream_transform, false)
    stream = RStream.map(stream, fn x -> if x > 2, do: throw(:error), else: x end)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_transform)
  end

  test "transform/4 is zippable with inner enum" do
    transform_fun = fn
      10, acc -> {:halt, acc}
      x, acc -> {x..(x + 2), acc}
    end

    after_fun = fn :inner -> Process.put(:stream_transform, true) end
    stream = RStream.transform(1..20, fn -> :inner end, transform_fun, after_fun)

    list = Enum.to_list(stream)
    Process.put(:stream_transform, false)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
    assert Process.get(:stream_transform)
  end

  test "scan/2" do
    stream = RStream.scan(1..5, &(&1 + &2))
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 3, 6, 10, 15]
    assert RStream.scan([], &(&1 + &2)) |> Enum.to_list() == []
  end

  test "scan/3" do
    stream = RStream.scan(1..5, 0, &(&1 + &2))
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 3, 6, 10, 15]
    assert RStream.scan([], 0, &(&1 + &2)) |> Enum.to_list() == []
  end

  test "take/2" do
    stream = RStream.take(1..1000, 5)
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 3, 4, 5]

    assert Enum.to_list(RStream.take(1..1000, 0)) == []
    assert Enum.to_list(RStream.take([], 5)) == []
    assert Enum.to_list(RStream.take(1..3, 5)) == [1, 2, 3]

    nats = RStream.iterate(1, &(&1 + 1))
    assert Enum.to_list(RStream.take(nats, 5)) == [1, 2, 3, 4, 5]

    stream = RStream.drop(1..100, 5)
    assert RStream.take(stream, 5) |> Enum.to_list() == [6, 7, 8, 9, 10]

    stream = 1..5 |> RStream.take(10) |> RStream.drop(15)
    assert {[], []} = Enum.split(stream, 5)

    stream = 1..20 |> RStream.take(10 + 5) |> RStream.drop(4)
    assert Enum.to_list(stream) == [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
  end

  test "take/2 does not consume next element on halt" do
    assert [false, true]
           |> RStream.each(&(&1 && raise("oops")))
           |> RStream.take(1)
           |> RStream.take_while(& &1)
           |> Enum.to_list() == []
  end

  test "take/2 does not consume next element on suspend" do
    assert [false, true]
           |> RStream.each(&(&1 && raise("oops")))
           |> RStream.take(1)
           |> RStream.flat_map(&[&1])
           |> Enum.to_list() == [false]
  end

  test "take/2 with negative count" do
    Process.put(:stream_each, [])

    stream = RStream.take(1..100, -5)
    assert lazy?(stream)

    stream = RStream.each(stream, &Process.put(:stream_each, [&1 | Process.get(:stream_each)]))

    assert Enum.to_list(stream) == [96, 97, 98, 99, 100]
    assert Process.get(:stream_each) == [100, 99, 98, 97, 96]
  end

  test "take/2 is zippable" do
    stream = RStream.take(1..1000, 5)
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "take_every/2" do
    assert 1..10
           |> RStream.take_every(2)
           |> Enum.to_list() == [1, 3, 5, 7, 9]

    assert 1..10
           |> RStream.take_every(3)
           |> Enum.to_list() == [1, 4, 7, 10]

    assert 1..10
           |> RStream.drop(2)
           |> RStream.take_every(2)
           |> RStream.drop(1)
           |> Enum.to_list() == [5, 7, 9]

    assert 1..10
           |> RStream.take_every(0)
           |> Enum.to_list() == []

    assert []
           |> RStream.take_every(10)
           |> Enum.to_list() == []
  end

  test "take_every/2 without non-negative integer" do
    assert_raise FunctionClauseError, fn ->
      RStream.take_every(1..10, -1)
    end

    assert_raise FunctionClauseError, fn ->
      RStream.take_every(1..10, 3.33)
    end
  end

  test "take_while/2" do
    stream = RStream.take_while(1..1000, &(&1 <= 5))
    assert lazy?(stream)
    assert Enum.to_list(stream) == [1, 2, 3, 4, 5]

    assert Enum.to_list(RStream.take_while(1..1000, &(&1 <= 0))) == []
    assert Enum.to_list(RStream.take_while(1..3, &(&1 <= 5))) == [1, 2, 3]

    nats = RStream.iterate(1, &(&1 + 1))
    assert Enum.to_list(RStream.take_while(nats, &(&1 <= 5))) == [1, 2, 3, 4, 5]

    stream = RStream.drop(1..100, 5)
    assert RStream.take_while(stream, &(&1 < 11)) |> Enum.to_list() == [6, 7, 8, 9, 10]
  end

  test "timer/1" do
    stream = RStream.timer(10)

    {time_us, value} = :timer.tc(fn -> Enum.to_list(stream) end)

    assert value == [0]
    # We check for >= 5000 (us) instead of >= 10000 (us)
    # because the resolution on Windows system is not high
    # enough and we would get a difference of 9000 from
    # time to time. So a value halfway is good enough.
    assert time_us >= 5000
  end

  test "timer/1 with infinity" do
    stream = RStream.timer(:infinity)
    spawn(RStream, :run, [stream])
  end

  test "unfold/2" do
    stream = RStream.unfold(10, fn x -> if x > 0, do: {x, x - 1} end)
    assert Enum.take(stream, 5) == [10, 9, 8, 7, 6]
    stream = RStream.unfold(5, fn x -> if x > 0, do: {x, x - 1} end)
    assert Enum.to_list(stream) == [5, 4, 3, 2, 1]
  end

  test "unfold/2 only calculates values if needed" do
    stream = RStream.unfold(1, fn x -> if x > 0, do: {x, x - 1}, else: throw(:boom) end)
    assert Enum.take(stream, 1) == [1]

    stream = RStream.unfold(5, fn x -> if x > 0, do: {x, x - 1} end)
    assert Enum.to_list(RStream.take(stream, 2)) == [5, 4]
  end

  test "unfold/2 is zippable" do
    stream = RStream.unfold(10, fn x -> if x > 0, do: {x, x - 1} end)
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  test "uniq_by/2" do
    assert RStream.uniq_by([{1, :x}, {2, :y}, {1, :z}], fn {x, _} -> x end)
           |> Enum.to_list() ==
             [{1, :x}, {2, :y}]

    assert RStream.uniq_by([a: {:tea, 2}, b: {:tea, 2}, c: {:coffee, 1}], fn {_, y} ->
             y
           end)
           |> Enum.to_list() == [a: {:tea, 2}, c: {:coffee, 1}]
  end

  test "zip/2" do
    concat = RStream.concat(1..3, 4..6)
    cycle = RStream.cycle([:a, :b, :c])

    assert RStream.zip(concat, cycle) |> Enum.to_list() ==
             [{1, :a}, {2, :b}, {3, :c}, {4, :a}, {5, :b}, {6, :c}]
  end

  test "zip_with/3" do
    concat = RStream.concat(1..3, 4..6)
    cycle = RStream.cycle([:a, :b, :c])
    zip_fun = &List.to_tuple([&1, &2])

    assert RStream.zip_with(concat, cycle, zip_fun) |> Enum.to_list() ==
             [{1, :a}, {2, :b}, {3, :c}, {4, :a}, {5, :b}, {6, :c}]

    stream = RStream.concat(1..3, 4..6)
    other_stream = fn _, _ -> {:cont, [1, 2]} end
    result = RStream.zip_with(stream, other_stream, fn a, b -> a + b end) |> Enum.to_list()
    assert result == [2, 4]
  end

  test "zip_with/2" do
    concat = RStream.concat(1..3, 4..6)
    cycle = RStream.cycle([:a, :b, :c])
    zip_fun = &List.to_tuple/1

    assert RStream.zip_with([concat, cycle], zip_fun) |> Enum.to_list() ==
             [{1, :a}, {2, :b}, {3, :c}, {4, :a}, {5, :b}, {6, :c}]

    assert RStream.chunk_every([0, 1, 2, 3], 2)
           |> RStream.zip_with(zip_fun)
           |> Enum.to_list() ==
             [{0, 2}, {1, 3}]

    stream = %HaltAcc{acc: 1..3}

    assert RStream.zip_with([1..3, stream], zip_fun) |> Enum.to_list() == [
             {1, 1},
             {2, 2},
             {3, 3}
           ]

    range_cycle = RStream.cycle(1..2)

    assert RStream.zip_with([1..3, range_cycle], zip_fun) |> Enum.to_list() == [
             {1, 1},
             {2, 2},
             {3, 1}
           ]
  end

  test "zip_with/2 does not leave streams suspended" do
    zip_with_fun = &List.to_tuple/1

    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_zip_with, true)
      end)

    Process.put(:stream_zip_with, false)

    assert RStream.zip_with([[:a, :b, :c], stream], zip_with_fun) |> Enum.to_list() == [
             a: 1,
             b: 2,
             c: 3
           ]

    assert Process.get(:stream_zip_with)

    Process.put(:stream_zip_with, false)

    assert RStream.zip_with([stream, [:a, :b, :c]], zip_with_fun) |> Enum.to_list() == [
             {1, :a},
             {2, :b},
             {3, :c}
           ]

    assert Process.get(:stream_zip_with)
  end

  test "zip_with/2 does not leave streams suspended on halt" do
    zip_with_fun = &List.to_tuple/1

    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_zip_with, :done)
      end)

    assert RStream.zip_with([[:a, :b, :c, :d, :e], stream], zip_with_fun) |> Enum.take(3) ==
             [
               a: 1,
               b: 2,
               c: 3
             ]

    assert Process.get(:stream_zip_with) == :done
  end

  test "zip_with/2 closes on inner error" do
    zip_with_fun = &List.to_tuple/1
    stream = RStream.into([1, 2, 3], %Pdict{})

    stream =
      RStream.zip_with(
        [stream, RStream.map([:a, :b, :c], fn _ -> throw(:error) end)],
        zip_with_fun
      )

    Process.put(:stream_done, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_done)
  end

  test "zip_with/2 closes on outer error" do
    zip_with_fun = &List.to_tuple/1

    stream =
      RStream.zip_with(
        [RStream.into([1, 2, 3], %Pdict{}), [:a, :b, :c]],
        zip_with_fun
      )
      |> RStream.map(fn _ -> throw(:error) end)

    Process.put(:stream_done, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_done)
  end

  test "zip/1" do
    concat = RStream.concat(1..3, 4..6)
    cycle = RStream.cycle([:a, :b, :c])

    assert RStream.zip([concat, cycle]) |> Enum.to_list() ==
             [{1, :a}, {2, :b}, {3, :c}, {4, :a}, {5, :b}, {6, :c}]

    assert RStream.chunk_every([0, 1, 2, 3], 2) |> RStream.zip() |> Enum.to_list() ==
             [{0, 2}, {1, 3}]

    stream = %HaltAcc{acc: 1..3}
    assert RStream.zip([1..3, stream]) |> Enum.to_list() == [{1, 1}, {2, 2}, {3, 3}]

    range_cycle = RStream.cycle(1..2)
    assert RStream.zip([1..3, range_cycle]) |> Enum.to_list() == [{1, 1}, {2, 2}, {3, 1}]
  end

  test "zip/1 does not leave streams suspended" do
    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_zip, true)
      end)

    Process.put(:stream_zip, false)
    assert RStream.zip([[:a, :b, :c], stream]) |> Enum.to_list() == [a: 1, b: 2, c: 3]
    assert Process.get(:stream_zip)

    Process.put(:stream_zip, false)

    assert RStream.zip([stream, [:a, :b, :c]]) |> Enum.to_list() == [
             {1, :a},
             {2, :b},
             {3, :c}
           ]

    assert Process.get(:stream_zip)
  end

  test "zip/1 does not leave streams suspended on halt" do
    stream =
      RStream.resource(fn -> 1 end, fn acc -> {[acc], acc + 1} end, fn _ ->
        Process.put(:stream_zip, :done)
      end)

    assert RStream.zip([[:a, :b, :c, :d, :e], stream]) |> Enum.take(3) == [
             a: 1,
             b: 2,
             c: 3
           ]

    assert Process.get(:stream_zip) == :done
  end

  test "zip/1 closes on inner error" do
    stream = RStream.into([1, 2, 3], %Pdict{})

    stream = RStream.zip([stream, RStream.map([:a, :b, :c], fn _ -> throw(:error) end)])

    Process.put(:stream_done, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_done)
  end

  test "zip/1 closes on outer error" do
    stream =
      RStream.zip([RStream.into([1, 2, 3], %Pdict{}), [:a, :b, :c]])
      |> RStream.map(fn _ -> throw(:error) end)

    Process.put(:stream_done, false)
    assert catch_throw(Enum.to_list(stream)) == :error
    assert Process.get(:stream_done)
  end

  test "with_index/2" do
    stream = RStream.with_index([1, 2, 3])
    assert lazy?(stream)
    assert Enum.to_list(stream) == [{1, 0}, {2, 1}, {3, 2}]

    stream = RStream.with_index([1, 2, 3], 10)
    assert Enum.to_list(stream) == [{1, 10}, {2, 11}, {3, 12}]

    nats = RStream.iterate(1, &(&1 + 1))
    assert RStream.with_index(nats) |> Enum.take(3) == [{1, 0}, {2, 1}, {3, 2}]
  end

  test "intersperse/2 is lazy" do
    assert lazy?(RStream.intersperse([], 0))
  end

  test "intersperse/2 on an empty list" do
    assert Enum.to_list(RStream.intersperse([], 0)) == []
  end

  test "intersperse/2 on a single element list" do
    assert Enum.to_list(RStream.intersperse([1], 0)) == [1]
  end

  test "intersperse/2 on a multiple elements list" do
    assert Enum.to_list(RStream.intersperse(1..3, 0)) == [1, 0, 2, 0, 3]
  end

  test "intersperse/2 is zippable" do
    stream = RStream.intersperse(1..10, 0)
    list = Enum.to_list(stream)
    assert Enum.zip(list, list) == Enum.zip(stream, stream)
  end

  @tag :skip
  defp lazy?(stream) do
    match?(%Stream{}, stream) or is_function(stream, 2)
  end

  defp inbox_stream({:suspend, acc}, f) do
    {:suspended, acc, &inbox_stream(&1, f)}
  end

  defp inbox_stream({:halt, acc}, _f) do
    {:halted, acc}
  end

  defp inbox_stream({:cont, acc}, f) do
    receive do
      {:stream, element} ->
        inbox_stream(f.(element, acc), f)
    end
  end
end
