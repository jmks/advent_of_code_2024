defmodule AdventOfCode2024.Day06Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day06

  @example """
           ....#.....
           .........#
           ..........
           ..#.......
           .......#..
           ..........
           .#..^.....
           ........#.
           #.........
           ......#...
           """
           |> String.trim()
           |> String.split("\n", trim: true)

  describe "parse/1" do
    test "all the tiles" do
      tiles =
        parse([
          ".#.",
          "v.."
        ])

      assert tiles == [
               {{0, 0}, :open},
               {{0, 1}, :obstacle},
               {{0, 2}, :open},
               {{1, 0}, {:guard, :down}},
               {{1, 1}, :open},
               {{1, 2}, :open}
             ]
    end

    test "example" do
      tiles = parse(@example)

      assert {{6, 4}, {:guard, :up}} in tiles
    end
  end

  describe "guard_visited/1" do
    test "example" do
      visited = @example |> parse() |> guard_visited()

      assert MapSet.size(visited) == 41
    end
  end
end
