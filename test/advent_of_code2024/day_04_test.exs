defmodule AdventOfCode2024.Day04Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day04

  @example """
           MMMSXXMASM
           MSAMXMSMSA
           AMXSXMAAMM
           MSAMASMSMX
           XMASAMXAMM
           XXAMMXXAMA
           SMSMSASXSS
           SAXAMASAAA
           MAMMMXMMMM
           MXMXAXMASX
           """
           |> String.split("\n", trim: true)

  describe "search/1" do
    test "horizontal" do
      assert search(["SAMX..XMAS..XMAS..SAMX"]) == 4
    end

    test "vertical" do
      assert search([
               "XS..",
               "MA..",
               "AM..",
               "SX.."
             ]) == 2
    end

    test "diagonal" do
      assert search([
               "X..S",
               ".MA.",
               ".MA.",
               "X..S"
             ]) == 2
    end

    test "example" do
      assert search(@example) == 18
    end
  end

  describe "x_mas_search/1" do
    test "example" do
      assert x_mas_search(@example) == 9
    end
  end
end
