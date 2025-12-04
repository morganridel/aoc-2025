defmodule Aoc2025.Solutions.Y25.Day04 do
  alias AoC.Input

  def neighbor_offsets,
    do: [
      {-1, -1},
      {0, -1},
      {1, -1},
      {-1, 0},
      {1, 0},
      {-1, 1},
      {0, 1},
      {1, 1}
    ]

  def parse(input, _part) do
    Input.stream!(input, trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Map.new()
  end

  def part_one(problem) do
    Map.keys(problem)
    # Only check position where roll is
    |> Enum.filter(&(Map.fetch!(problem, &1) == "@"))
    |> Enum.map(&valid_adjacent_positions(problem, &1))
    |> Enum.filter(&(Enum.count(&1.valid_adjacents) < 4))
    |> Enum.count()
  end

  def part_two(problem) do
    problem
    |> remove_rolls(0)
  end

  defp remove_rolls(problem, removed_count) do
    removable_positions =
      Map.keys(problem)
      # Only check position where roll is
      |> Enum.filter(&(Map.fetch!(problem, &1) == "@"))
      |> Enum.map(&valid_adjacent_positions(problem, &1))
      |> Enum.filter(&(Enum.count(&1.valid_adjacents) < 4))

    new_map =
      removable_positions
      |> Enum.map(fn x -> x.position end)
      |> Enum.reduce(problem, fn key, acc ->
        Map.put(acc, key, ".")
      end)

    # Remove valid rolls and continue
    case count = Enum.count(removable_positions) do
      0 ->
        removed_count

      _ ->
        remove_rolls(new_map, removed_count + count)
    end
  end

  defp valid_adjacent_positions(map, position = {x, y}) when is_integer(x) and is_integer(y) do
    # IO.puts("At position " <> Integer.to_string(x) <> ":" <> Integer.to_string(y))

    %{
      position: position,
      valid_adjacents:
        neighbor_offsets()
        |> Enum.reduce([], fn {dx, dy}, acc ->
          # IO.puts("getting" <> Integer.to_string(x + dx) <> ":" <> Integer.to_string(y + dy))
          neighbor = {x + dx, y + dy}

          case Map.get(map, neighbor, ".") do
            "@" -> [neighbor | acc]
            _ -> acc
          end
        end)
    }
  end
end
