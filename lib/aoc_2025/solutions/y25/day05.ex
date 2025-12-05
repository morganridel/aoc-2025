defmodule Aoc2025.Solutions.Y25.Day05 do
  alias Aoc2025.Utils
  alias AoC.Input

  def parse(input, _part) do
    {ranges, available} =
      Input.stream!(input)
      |> Enum.split_while(&(String.trim(&1) != ""))
      |> then(fn {ranges, available} ->
        {ranges |> Utils.trim_list(), available |> tl() |> Utils.trim_list()}
      end)

    %{
      ranges: ranges |> Enum.map(&parse_range(&1)),
      available: available
    }
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem.available
    |> Enum.filter(&(problem.ranges |> Enum.any?(fn range -> String.to_integer(&1) in range end)))
    |> Enum.count()
  end

  def part_two(problem) do
    problem.ranges
    |> Enum.sort()
    |> Enum.reduce([], fn range = left..right//1, acc ->
      case acc do
        [] ->
          [range]

        # Merge if range overlap
        [previous_left..previous_right//1 | rest] when left in previous_left..previous_right//1 ->
          [previous_left..max(right, previous_right) | rest]

        _ ->
          [range | acc]
      end
    end)
    |> Enum.map(&Enum.count(&1))
    |> Enum.sum()
  end

  defp parse_range(range) do
    [left, right] = range |> String.split("-")
    String.to_integer(left)..String.to_integer(right)
  end
end
