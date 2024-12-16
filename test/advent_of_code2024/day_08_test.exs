defmodule AdventOfCode2024.Day08Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day08

  @example """
           ............
           ........0...
           .....0......
           .......0....
           ....0.......
           ......A.....
           ............
           ............
           ........A...
           .........A..
           ............
           ............
           """
           |> String.trim()
           |> String.split("\n", trim: true)

  describe "parse/1" do
    test "example" do
      parsed = parse(@example)

      assert {{1, 8}, "0"} in parsed
      assert {{8, 8}, "A"} in parsed
    end
  end

  describe "antinodes/4" do
    test "in a line" do
      assert antinodes({2, 3}, {2, 5}, 1..10, 1..10) == [{2, 1}, {2, 7}]
    end

    test "diagonal" do
      assert antinodes({3, 4}, {5, 5}, 1..10, 1..10) == [{1, 3}, {7, 6}]
    end

    test "filters antinodes out of range" do
      assert antinodes({2, 3}, {2, 5}, 1..5, 1..5) == [{2, 1}]
    end
  end

  describe "antinodes_with_harmonics/4" do
    test "all nodes in a horizontal line" do
      assert(
        antinodes_with_harmonics({3, 1}, {5, 1}, 1..10, 1..10) == [
          {1, 1},
          {3, 1},
          {5, 1},
          {7, 1},
          {9, 1}
        ]
      )
    end
  end

  describe "unique_locations_with_antinodes/2" do
    test "example part 1" do
      locations = unique_locations_with_antinodes(parse(@example))

      assert length(locations) == 14
    end

    test "example part 2" do
      locations = unique_locations_with_antinodes(parse(@example), &antinodes_with_harmonics/4)

      assert length(locations) == 34
    end
  end

  test "pairwise/1" do
    assert pairwise([1, 2, 3]) == [{1, 2}, {1, 3}, {2, 3}]
    assert pairwise([]) == []
    assert pairwise([1]) == []
  end
end
