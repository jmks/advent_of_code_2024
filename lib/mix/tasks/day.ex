defmodule Mix.Tasks.Day do
  use Mix.Task

  def run([day]) do
    padded_day = normalized_day(day)

    lib_file(padded_day)
    test_file(padded_day)
    File.touch!("lib/inputs/#{padded_day}")
  end

  defp lib_file(day) do
    filename = "day_#{day}.ex"
    path = Path.join(["lib/advent_of_code2024/", filename])

    unless File.exists?(path) do
      File.write(
        path,
        """
        defmodule AdventOfCode2024.Day#{day} do
          @moduledoc \"\"\"

          \"\"\"

          def part1 do
          end

          def part2 do
          end
        end
        """
      )
    end
  end

  defp test_file(day) do
    filename = "day_#{day}_test.exs"
    path = Path.join(["test/advent_of_code2024/", filename])

    unless File.exists?(path) do
      File.write(
        path,
        """
        defmodule AdventOfCode2024.Day#{day}Test do
          use ExUnit.Case, async: true

          import AdventOfCode2024.Day#{day}

          describe "some_func/1" do
            test "some condition" do
              assert true
            end
          end
        end
        """
      )
    end
  end

  defp normalized_day(day) do
    String.pad_leading(day, 2, "0")
  end
end
