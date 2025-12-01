defmodule Aoc2025.Utils do
  def debug_inspect(enumerable), do: Enum.map(enumerable, &IO.inspect/1)
end
