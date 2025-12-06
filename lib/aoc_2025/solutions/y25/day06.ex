defmodule Aoc2025.Solutions.Y25.Day06 do
  alias Aoc2025.Utils
  alias AoC.Input

  def parse(input, part) do
    case part do
      :part_one ->
        Input.stream!(input, trim: true)
        |> Enum.map(&String.split(&1))

      :part_two ->
        IO.puts("part two:")

        chars =
          Input.read!(input)
          |> String.split("\n")
          # Remove last new line
          |> Enum.drop(-1)
          |> Enum.map(&String.graphemes/1)

        max_length = Enum.max_by(chars, &length/1) |> length()

        # Pad to get the same amount of characters in every list
        chars |> Enum.map(&pad_list(&1, max_length))
    end
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(fn el ->
      case List.pop_at(el, -1) do
        {"+", list} -> list |> Utils.parse_ints() |> Enum.sum()
        {"*", list} -> list |> Utils.parse_ints() |> Enum.reduce(1, &(&1 * &2))
      end
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    # [
    #   ["1", "2", "3", " ", "3", "2", "8", " ", " ", "5", "1", " ", "6", "4", ""],
    #   [" ", "4", "5", " ", "6", "4", " ", " ", "3", "8", "7", " ", "2", "3", ""],
    #   [" ", " ", "6", " ", "9", "8", " ", " ", "2", "1", "5", " ", "3", "1", "4"],
    #   ["*", " ", " ", " ", "+", " ", " ", " ", "*", " ", " ", " ", "+", "", ""]
    # ]
    |> IO.inspect()
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))

    # We get a list of columns now
    # [
    #   ["1", " ", " ", "*"],
    #   ["2", "4", " ", " "],
    #   ["3", "5", "6", " "],
    #   [" ", " ", " ", " "],
    #   ["3", "6", "9", "+"],
    #   ["2", "4", "8", " "],
    #   ["8", " ", " ", " "],
    #   [" ", " ", " ", " "],
    #   [" ", "3", "2", "*"],
    #   ["5", "8", "1", " "],
    #   ["1", "7", "5", " "],
    #   [" ", " ", " ", " "],
    #   ["6", "2", "3", "+"],
    #   ["4", "3", "1", ""],
    #   ["", "", "4", ""]
    # ]
    |> IO.inspect()
    # Cut on every completely empty column
    |> Enum.chunk_by(&Enum.all?(&1, fn x -> x == " " end))
    # [
    #   [["1", " ", " ", "*"], ["2", "4", " ", " "], ["3", "5", "6", " "]],
    #   [[" ", " ", " ", " "]],
    #   [["3", "6", "9", "+"], ["2", "4", "8", " "], ["8", " ", " ", " "]],
    #   [[" ", " ", " ", " "]],
    #   [[" ", "3", "2", "*"], ["5", "8", "1", " "], ["1", "7", "5", " "]],
    #   [[" ", " ", " ", " "]],
    #   [["6", "2", "3", "+"], ["4", "3", "1", ""], ["", "", "4", ""]]
    # ]
    |> IO.inspect()
    # Then remove the empty column
    |> Enum.take_every(2)
    # [
    #   [["1", " ", " ", "*"], ["2", "4", " ", " "], ["3", "5", "6", " "]],
    #   [["3", "6", "9", "+"], ["2", "4", "8", " "], ["8", " ", " ", " "]],
    #   [[" ", "3", "2", "*"], ["5", "8", "1", " "], ["1", "7", "5", " "]],
    #   [["6", "2", "3", "+"], ["4", "3", "1", ""], ["", "", "4", ""]]
    # ]
    |> IO.inspect()
    # Now we just extract our math problem
    |> Enum.map(fn el ->
      %{
        operator: List.first(el) |> List.last(),
        numbers:
          el
          |> IO.inspect()
          |> Enum.map(fn item ->
            item
            |> Enum.drop(-1)
            |> Enum.join()
            |> String.trim()
            |> String.to_integer()
          end)
      }
    end)
    # [
    #   %{operator: "*", numbers: [1, 24, 356]},
    #   %{operator: "+", numbers: [369, 248, 8]},
    #   %{operator: "*", numbers: [32, 581, 175]},
    #   %{operator: "+", numbers: [623, 431, 4]}
    # ]
    |> IO.inspect()
    # And solve it
    |> Enum.map(fn math_problem ->
      case math_problem do
        %{operator: "+", numbers: list} ->
          list |> Enum.sum()

        %{operator: "*", numbers: list} ->
          list |> Enum.reduce(1, &(&1 * &2))
      end
    end)
    |> Enum.sum()
  end

  def pad_list(list, size) do
    list ++ List.duplicate(" ", size - length(list))
  end
end
