defmodule AdventOfCode2024.Day12Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day12

  @small """
         AAAA
         BBCD
         BBCC
         EEEC
         """
         |> String.split("\n", trim: true)

  @larger """
          RRRRIICCFF
          RRRRIICCCF
          VVRRRCCFFF
          VVRCCCJFFF
          VVVVCJJCFE
          VVIVCCJJEE
          VVIIICJJEE
          MIIIIIJJEE
          MIIISIJEEE
          MMMISSJEEE
          """
          |> String.split("\n", trim: true)

  describe "parse/1" do
    test "small" do
      parsed = parse(@small)

      assert {{0, 0}, "A"} in parsed
      assert {{1, 3}, "D"} in parsed
      assert {{3, 2}, "E"} in parsed
    end
  end

  describe "groups/1" do
    test "small" do
      groups = @small |> parse() |> groups()

      assert MapSet.size(groups) == 5
      assert {"A", MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}])} in groups
      assert {"B", MapSet.new([{1, 0}, {1, 1}, {2, 0}, {2, 1}])} in groups
      assert {"C", MapSet.new([{1, 2}, {2, 2}, {2, 3}, {3, 3}])} in groups
      assert {"D", MapSet.new([{1, 3}])} in groups
      assert {"E", MapSet.new([{3, 0}, {3, 1}, {3, 2}])} in groups
    end

    test "larger" do
      groups = @larger |> parse() |> groups()

      assert MapSet.size(groups) == 11
    end
  end

  describe "group_dimensions/1" do
    test "small" do
      assert group_dimension(MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}])) == {4, 10}
      assert group_dimension(MapSet.new([{1, 0}, {1, 1}, {2, 0}, {2, 1}])) == {4, 8}
      assert group_dimension(MapSet.new([{1, 2}, {2, 2}, {2, 3}, {3, 3}])) == {4, 10}
      assert group_dimension(MapSet.new([{1, 3}])) == {1, 4}
      assert group_dimension(MapSet.new([{3, 0}, {3, 1}, {3, 2}])) == {3, 8}
    end
  end

  describe "total_price/1" do
    test "larger" do
        assert total_price(@larger) == 1930
    end
  end
end
