defmodule Aoc2025.Utils do
  def debug_inspect(enumerable), do: Enum.map(enumerable, &IO.inspect/1)

  def trim_list(enumerable), do: enumerable |> Enum.map(&String.trim(&1))
end
