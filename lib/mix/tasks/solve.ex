defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, "1"]) do
    IO.inspect(apply(module(day), :part1, []))
  end

  def run([day, "2"]) do
    IO.inspect(apply(module(day), :part2, []))
  end

  defp module(day) do
    Module.safe_concat([AdventOfCode2024, "Day" <> String.pad_leading(day, 2, "0")])
  end
end
