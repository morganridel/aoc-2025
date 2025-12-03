defmodule Aoc2025.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input, trim: true)
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.map(&String.to_integer/1) end)
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.map(fn list ->
      # First number can't be the last one of the list
      slice = Enum.slice(list, 0, length(list) - 1)
      {first, index} = leftmost_max(slice)
      # Highest number after the first highest
      {second, _} = leftmost_max(Enum.slice(list, index + 1, length(list)))
      concatenate_numbers(first, second)
    end)
    |> IO.inspect(charlists: false)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map(&handle_line/1)
    |> IO.inspect(charlists: false)
    |> Enum.sum()
  end

  defp handle_line(list) when is_list(list) do
    11..0//-1
    |> Enum.reduce([], fn i, acc ->
      # Start after the previous number
      start_from_index =
        case acc do
          [] -> 0
          [{_, index} | _] -> index + 1
        end

      # We want to keep at least 1-11 elements later in the list because we need 12 numbers total
      slice = Enum.slice(list, start_from_index, length(list) - start_from_index - i)

      {max, max_index} = leftmost_max(slice)

      # We build the list in reverse just for simpler pattern matching
      [{max, start_from_index + max_index} | acc]
    end)
    |> Enum.map(fn {number, _} -> number end)
    |> Enum.reverse()
    |> Enum.reduce(nil, &concatenate_numbers(&2, &1))
  end

  # returns {max, index}
  defp leftmost_max(list) when is_list(list) do
    max = Enum.max(list)
    {max, Enum.find_index(list, &(&1 == max))}
  end

  defp concatenate_numbers(n1, n2) do
    case n1 do
      nil -> n2
      _ -> (to_string(n1) <> to_string(n2)) |> String.to_integer()
    end
  end
end
