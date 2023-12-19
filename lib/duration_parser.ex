defmodule DurationParser do
  @moduledoc """
  Documentation for `DurationParser`.
  """


  @spec duration([{:microseconds, Integer.t() | Float.t()} | {:microsecond, Integer.t() | Float.t()} | {:milliseconds, Integer.t() | Float.t()} | {:millisecond, Integer.t() | Float.t()} | {:seconds, Integer.t() | Float.t()} | {:second, Integer.t() | Float.t()} | {:minutes, Integer.t() | Float.t()} | {:hours, Integer.t() | Float.t()} | {:days, Integer.t() | Float.t()} | {:weeks, Integer.t() | Float.t()}]) :: Timex.Duration.t()

  def duration(chunks) do
    create_duration(Timex.Duration.zero(), chunks)
  end

  defp create_duration(duration, []) do
    duration
  end


  defp create_duration(duration, [{:microsecond, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_microseconds(x)), tail)
  end
  defp create_duration(duration, [{:microseconds, x} | tail]) do
    create_duration(duration, [{:microsecond, x} | tail])
  end

  defp create_duration(duration, [{:ms, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_milliseconds(x)), tail)
  end

  defp create_duration(duration, [{:milliseconds, x} | tail]) do
    create_duration(duration, [{:ms, x} | tail])
  end

  defp create_duration(duration, [{:millisecond, x} | tail]) do
    create_duration(duration, [{:ms, x} | tail])
  end


  defp create_duration(duration, [{:s, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_seconds(x)), tail)
  end

  defp create_duration(duration, [{:second, x} | tail]) do
    create_duration(duration, [{:s, x} | tail])
  end
  defp create_duration(duration, [{:seconds, x} | tail]) do
    create_duration(duration, [{:s, x} | tail])
  end


  defp create_duration(duration, [{:m, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_minutes(x)), tail)
  end

  defp create_duration(duration, [{:minutes, x} | tail]) do
    create_duration(duration, [{:m, x} | tail])
  end

  defp create_duration(duration, [{:minute, x} | tail]) do
    create_duration(duration, [{:m, x} | tail])
  end

  defp create_duration(duration, [{:h, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_hours(x)), tail)
  end

  defp create_duration(duration, [{:hours, x} | tail]) do
    create_duration(duration, [{:h, x} | tail])
  end

  defp create_duration(duration, [{:hour, x} | tail]) do
    create_duration(duration, [{:h, x} | tail])
  end

  defp create_duration(duration, [{:d, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_days(x)), tail)
  end

  defp create_duration(duration, [{:day, x} | tail]) do
    create_duration(duration, [{:d, x} | tail])
  end

  defp create_duration(duration, [{:days, x} | tail]) do
    create_duration(duration, [{:d, x} | tail])
  end

  defp create_duration(duration, [{:w, x} | tail]) do
    create_duration(Timex.Duration.add(duration, Timex.Duration.from_weeks(x)), tail)
  end

  defp create_duration(duration, [{:week, x} | tail]) do
    create_duration(duration, [{:w, x} | tail])
  end

  defp create_duration(duration, [{:weeks, x} | tail]) do
    create_duration(duration, [{:w, x} | tail])
  end



  #  @spec parse(string()) :: Timex.Duration.t()

  def parse(input) do
    regex = ~r/(\d+)\s*(milliseconds|millisecond|ms|seconds|second|secs|s|minutes|minute|mins|min|m|hours|hour|hrs|h|days|day|d|weeks|week|wks|wk|w)(?=\s|\z)/
    Regex.scan(regex, input)  |> Enum.map( fn [_, v, u] -> {val, ""} = Float.parse(v);{convert_to_atom_form(u), val} end)
    |> duration()
  end

  def convert_to_atom_form(time_unit_string) do
    case time_unit_string do
      "milliseconds" -> :millisecond
      "millisecond" -> :millisecond
      "ms" -> :millisecond
      "seconds" -> :second
      "second" -> :second
      "secs" -> :second
      "s" -> :second
      "minutes" -> :minutes
      "minute" -> :minutes
      "mins" -> :minutes
      "min" -> :minutes
      "m" -> :minutes
      "hours" -> :hours
      "hour" -> :hours
      "hrs" -> :hours
      "h" -> :hours
      "days" -> :days
      "day" -> :days
      "d" -> :days
      "weeks" -> :weeks
      "week" -> :weeks
      "wks" -> :weeks
      "wk" -> :weeks
      "w" -> :weeks
      _ -> raise "Unknown time unit #{inspect time_unit_string}"
    end
  end
end
