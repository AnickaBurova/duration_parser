defmodule DurationParser do
  @moduledoc """
  Documentation for `DurationParser`.
  """


  @spec duration([{:microseconds, Integer.t() | Float.t()} | {:microsecond, Integer.t() | Float.t()} | {:milliseconds, Integer.t() | Float.t()} | {:millisecond, Integer.t() | Float.t()} | {:seconds, Integer.t() | Float.t()} | {:second, Integer.t() | Float.t()} | {:minutes, Integer.t() | Float.t()} | {:hours, Integer.t() | Float.t()} | {:days, Integer.t() | Float.t()} | {:weeks, Integer.t() | Float.t()}]) :: Timex.Duration.t()

  @doc """
    Converts a keyword list of individual durations into a single `Timex.Duration.t()` by adding them together.
    Each keyword in the list consists of a time unit key and its corresponding value.
    In case of any invalid input, this will raise an error.
  """
  def duration!(chunks) do
    create_duration(Timex.Duration.zero(), chunks)
  end

  @doc """
    Similar to `duration!/1`, but instead of raising an error for invalid inputs, this function returns `{:error, term()}`.
  """
  def duration(chunks) do
    try do
      {:ok, duration!(chunks)}
    rescue
      error ->
        {:error, error}
    end
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

  defp create_duration(_, _) do
    raise "Invalid input"
  end


  #  @spec parse(string()) :: Timex.Duration.t()
  @value_unit ~r/(\d+)\s*(milliseconds|millisecond|ms|seconds|second|secs|s|minutes|minute|mins|min|m|hours|hour|hrs|h|days|day|d|weeks|week|wks|wk|w)(?=\s|\z)/
  @doc """
    Parses a string to extract duration values, sums them into a single duration, and returns the computed `Timex.Duration.t()`.
    The input string can have various duration units including partial unit names like 'min' for minutes, written in any combination of lowercase or uppercase.
    It ignores any non-duration text present in the input string.
  """
  def extract_duration(input) do
      Regex.scan(@value_unit, input)
      |> Enum.map( fn [_, v, u] -> {val, ""} = Float.parse(v);{convert_to_atom_form(u), val} end)
      |> duration!()
  end

  @value_unit_with_error ~r/(?:(?:(\d+)\s*(milliseconds|millisecond|ms|seconds|second|secs|s|minutes|minute|mins|min|m|hours|hour|hrs|h|days|day|d|weeks|week|wks|wk|w))|(\w+))/

  @doc """
    Parse the input string if the text only contains valid durations (value unit). If there is a text which does not parse in to a duration, error is returned.
"""
  def parse(input)do
    try do
      {:ok, parse!(input)}
    rescue
      error ->
        {:error, error}
    end
  end

  @doc """
    Same as parse/1, but returns the duration on success, or raises an exception on any failed parsing.
"""
  def parse!(input) do
    Regex.scan(@value_unit_with_error, input)
    |> Enum.map( fn match -> case match do
       [_, v, u] ->
          {val, ""} = Float.parse(v)
          {convert_to_atom_form(u), val}
       [text | _] ->
         raise "Invalid input #{text}"
    end end)
    |> duration!()
  end

  defp convert_to_atom_form(time_unit_string) do
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
