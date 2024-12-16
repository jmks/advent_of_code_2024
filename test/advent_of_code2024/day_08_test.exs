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

  describe "antinodes/2" do
    test "in a line" do
      assert antinodes({2, 3}, {2, 5}) == [{2, 1}, {2, 7}]
    end

    test "diagonal" do
      assert antinodes({3, 4}, {5, 5}) == [{1, 3}, {7, 6}]
    end
  end

  describe "unique_locations_with_antinodes/1" do
    test "example" do
      locations = unique_locations_with_antinodes(parse(@example))

      assert length(locations) == 14
    end
  end

  test "pairwise/1" do
    assert pairwise([1,2,3]) == [{1,2}, {1,3}, {2, 3}]
    assert pairwise([]) == []
    assert pairwise([1]) == []
  end
end
