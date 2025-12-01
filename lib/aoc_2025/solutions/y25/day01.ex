defmodule Aoc2025.Solutions.Y25.Day01 do
  alias Aoc2025.Utils
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input, trim: true)
    |> Enum.map(&parse_rotation/1)
  end

  def part_one(rotations) do
    initial_dial = 50

    rotations
    |> Enum.scan(
      initial_dial,
      # Modulo 100 to "rotate" around the number range
      fn new_rotation, acc -> Integer.mod(acc + new_rotation, 100) end
    )
    |> Enum.count(&(&1 == 0))
  end

  def part_two(rotations) do
    rotations
    |> Enum.reduce(
      %{
        dial: 50,
        went_through_zero: 0
      },
      fn new_rotation, acc ->
        absolute_dial = acc.dial + new_rotation
        dial_after_rotation = Integer.mod(absolute_dial, 100)

        went_through_zero =
          case new_rotation do
            _ when acc.dial == 0 ->
              div(abs(new_rotation), 100)

            _ when new_rotation < 0 ->
              div(100 - acc.dial + abs(new_rotation), 100)

            _ ->
              div(acc.dial + abs(new_rotation), 100)
          end

        %{
          dial: dial_after_rotation,
          went_through_zero: acc.went_through_zero + went_through_zero
        }
      end
    )
    |> Map.get(:went_through_zero)
  end

  defp parse_rotation("R" <> amount), do: String.to_integer(amount)
  defp parse_rotation("L" <> amount), do: String.to_integer(amount) * -1
end
