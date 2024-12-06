defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, "1"]) do
    mod = Module.safe_concat([AdventOfCode2024, "Day" <> String.pad_leading(day, 2, "0")])

    IO.inspect(apply(mod, :part1, []))
  end

  def run([_day, "2"]) do
  end
end
