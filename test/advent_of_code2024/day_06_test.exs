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

  describe "guard_loops?/2" do
    test "simple loop" do
      map =
        """
        ####
        ...#
        .^..
        #...
        ####
        """
        |> String.trim()
        |> String.split("\n", trim: true)

      assert guard_loops?(parse(map))
    end

    test "example" do
      example = parse(@example)

      refute guard_loops?(example)
      assert guard_loops?(replace_tile(example, {6, 3}, :obstacle))
      assert guard_loops?(replace_tile(example, {7, 6}, :obstacle))
      assert guard_loops?(replace_tile(example, {7, 7}, :obstacle))
      assert guard_loops?(replace_tile(example, {8, 1}, :obstacle))
      assert guard_loops?(replace_tile(example, {8, 3}, :obstacle))
      assert guard_loops?(replace_tile(example, {9, 7}, :obstacle))
    end
  end

  describe "obstacles_causing_loops/1" do
    test "simple loop" do
      tiles =
        as_tiles("""
        ####
        ....
        .^..
        #...
        ####
        """)

      refute guard_loops?(tiles)
      assert obstacles_causing_loops(tiles) == MapSet.new([{1, 3}])
    end

    test "example" do
      assert obstacles_causing_loops(parse(@example)) ==
               MapSet.new([
                 {6, 3},
                 {7, 6},
                 {7, 7},
                 {8, 1},
                 {8, 3},
                 {9, 7}
               ])
    end
  end

  defp as_tiles(map) do
    map
    |> String.trim()
    |> String.split("\n", trim: true)
    |> parse()
  end

  def replace_tile(tiles, coordinate, new_value) do
    Enum.map(tiles, fn
      {^coordinate, _old_value} -> {coordinate, new_value}
      otherwise -> otherwise
    end)
  end
end
