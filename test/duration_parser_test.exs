defmodule DurationParserTest do
  use ExUnit.Case
  doctest DurationParser
  alias DurationParser, as: DP

  test "creating duration" do
    assert DP.duration!(m: 1, s: 33) == (Timex.Duration.from_seconds(60 + 33))
    assert DP.duration!(m: 1, m: 3) == (Timex.Duration.from_seconds(60 * 4))
  end

  describe "duration/1" do
    test "parses duration with all units shortened" do
      # Test with m, s, ms
      assert DP.duration!(m: 1, s: 33, ms: 10)   == Timex.Duration.from_milliseconds(10 + 33 * 1_000 + 60 * 1_000)
    end

    test "parses duration with all units in full form" do
      # Test with minute, second, millisecond
      assert DP.duration!(minute: 1, second: 33, millisecond: 10) == Timex.Duration.from_milliseconds(10 + 33 * 1_000 + 60 * 1_000)
    end

    test "parses duration with repeating units" do
      # Test repeating units, should add up
      assert DP.duration!(m: 4, m: 3) == Timex.Duration.from_minutes(7)
      assert DP.duration!(second: 45, s: 15) == Timex.Duration.from_seconds(60)
      assert DP.duration!(millisecond: 500, ms: 500) == Timex.Duration.from_milliseconds(1_000)
    end
  end

  describe "parse/1" do
    test "Parse string defined duration" do
      assert DP.parse!("1m 33s 10ms") == Timex.Duration.from_milliseconds(10 + 33 * 1_000 + 60 * 1_000)
      assert DP.parse!("1m 3m 10ms") == Timex.Duration.from_milliseconds(10 + 3 * 1_000 * 60 + 60 * 1_000)
    end

    test "Reverse and any order" do
      assert DP.parse!("33h 1m 6s") == DP.parse!("1m 6s 33h")
    end
  end
end