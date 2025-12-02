defmodule Aoc2025.Solutions.Y25.Day02 do
  alias ElixirLS.LanguageServer.Plugins.Util
  alias Aoc2025.Utils
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  def part_one(problem) do
    problem
    # We take a "reverse" approach and generate all invalid ids in each range instead of bruteforcing
    |> Enum.map(&generate_invalid_id(&1, :part_one))
    |> Enum.flat_map(& &1)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    # We take a "reverse" approach and generate all invalid ids in each range instead of bruteforcing
    |> Enum.map(&generate_invalid_id(&1, :part_two))
    |> Enum.flat_map(& &1)
    |> Enum.sum()
  end

  defp parse_range(range) do
    [left, right] = range |> String.split("-")
    {String.to_integer(left), String.to_integer(right)}
  end

  defp generate_invalid_id({left, right}, part) do
    left_digit_count = left |> Integer.digits() |> length()
    right_digit_count = right |> Integer.digits() |> length()

    # All numbers that when repeated has an amount of digits outside the
    # range of digits will by definition not be in the range
    digit_range = left_digit_count..right_digit_count

    min =
      case part do
        # smallest number that can be repeated and have enough digits
        # i.e if left range is 65479, smallest is 100 (100100 is the first >= to the range)
        :part_one -> 10 ** (ceil(left_digit_count / 2) - 1)
        # In part two, numbers can be repeated multiple times, so min starts at 1
        :part_two -> 1
      end

    # biggest number that can be repeated and have enough digits
    # i.e 1188511880 -> 99999
    # We could say that 11885 works and remove a lot more but it seems to behave weird
    # if left and right range have the same number of digits
    max =
      "9"
      |> String.duplicate(right_digit_count |> div(2))
      |> String.to_integer()

    # Our min..max range allow us to not build repetitions for
    # a good amount of number that wouldn't have the correct amount of digits

    # Now we iterate and repeat for each possible number

    repeat_function =
      case part do
        :part_one -> &generate_repeats/1
        :part_two -> &generate_repeats(&1, digit_range)
      end

    repeats =
      min..max
      |> Enum.flat_map(repeat_function)
      # We have a lot of duplicate in part 2 (1 repeated 4 times is same as 11 repeated twice)
      |> Enum.uniq()
      # our numbers should have a correct amount of digits but might not be in the range
      |> Enum.filter(&(&1 in left..right))

    # Debug
    IO.inspect(%{
      original: left..right,
      digit_range: digit_range,
      min: min,
      max: max,
      repeats: repeats
    })

    repeats
  end

  defp generate_repeats(number) do
    [number |> repeat_number_times(2)]
  end

  defp generate_repeats(number, min_digits..max_digits//_) do
    # We keep all the repetition that has enough digits
    #  i.e number is valid if it has 5..10 digits, we can repeat 12, we keep 121212, 12121212, 1212121212
    number_digits = number |> Integer.digits() |> length()
    # Min 2 repetitions
    min_repeat_amount = max(2, ceil(min_digits / number_digits))
    max_repeat_amount = floor(max_digits / number_digits)

    case min_repeat_amount > max_repeat_amount do
      true ->
        []

      _ ->
        min_repeat_amount..max_repeat_amount
        |> Enum.map(fn n ->
          number |> repeat_number_times(n)
        end)
    end
  end

  defp repeat_number_times(number, n),
    do: number |> Integer.to_string() |> String.duplicate(n) |> String.to_integer()
end
