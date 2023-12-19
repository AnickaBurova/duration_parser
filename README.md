# DurationParser

`DurationParser` is an Elixir module that facilitates the parsing of durations expressed in various time units into a unified format. The aim of this module is to create an easy-to-use Elixir interface to handle time durations.

## Installation

```Elixir
def deps do
    [
        {:duration_parser, github: "AnickaBurova/duration_parser"}
    ]
end
```


## Usage
You can pass keywords of units with their values to the duration/1 to create a duration. The list does not need to be ordered and even can have same units multiple times, it will add each value to the final duration.

```elixir
    # Creating a duration of 4 millisecond, 3 seconds, and 1 minute:
    iex> DurationParser.duration!(ms: 4, s: 3, m: 1)
    #<Duration(PT1M3.004S)
```
Function duration/1 will return {:ok, duration} or {:error, error} on incorrect input.

To parse a string which contains the duration, use the parse/1 function. The string is space delimited list of individual values and their units. The same unit can be used multiple times, as in the duration/1 function, and the values will be added to the final duration. The values can be in any order.

```elixir
    # Parsing string containing the duration represented with individual values and their units
    iex> DurationParser.parse!("1m 1w 33s 5 hours")
    #<Duration(P7DT5H1M33S)>
```
The function parse/1 will return {:ok, duration} or {:error, error} on failure to parse.

The function extract_duration will parse an entire string and will gather all the durations, ignoring any non-duration text, and returning the final duration. If there is no duration in the input, zero duration is returned.
```elixir
   iex> DurationParser.extract_duration("Hello 33s world 2minutes hohoho")
   #<Duration(PT2M33S)>
```