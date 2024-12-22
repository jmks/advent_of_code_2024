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

  @e_shape """
           EEEEE
           EXXXX
           EEEEE
           EXXXX
           EEEEE
           """
           |> String.split("\n", trim: true)

  @inner """
         AAAAAA
         AAABBA
         AAABBA
         ABBAAA
         ABBAAA
         AAAAAA
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

  describe "outer_edges/1" do
    test "prefers top and right directions" do
      assert outer_edges({0, 0}) == [
               {0, 0, :top, {0, 0}},
               {1, 0, :top, {0, 0}},
               {0, 0, :right, {0, 0}},
               {0, -1, :right, {0, 0}}
             ]
    end
  end

  describe "group_dimensions/1" do
    test "small A" do
      assert group_dimension(MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}])) == {4, 10, 4}
    end

    test "small B" do
      assert group_dimension(MapSet.new([{1, 0}, {1, 1}, {2, 0}, {2, 1}])) == {4, 8, 4}
    end

    test "small C" do
      assert group_dimension(MapSet.new([{1, 2}, {2, 2}, {2, 3}, {3, 3}])) == {4, 10, 8}
    end

    test "small D" do
      assert group_dimension(MapSet.new([{1, 3}])) == {1, 4, 4}
    end

    test "small E" do
      assert group_dimension(MapSet.new([{3, 0}, {3, 1}, {3, 2}])) == {3, 8, 4}
    end
  end

  describe "total_price/1" do
    test "larger" do
      assert total_price(@larger) == 1930
    end
  end

  describe "discount_price/1" do
    test "small" do
      assert discount_price(@small) == 80
    end

    test "e" do
      assert discount_price(@e_shape) == 236
    end

    test "larger" do
      assert discount_price(@larger) == 1206
    end

    test "inner" do
      assert discount_price(@inner) == 368
    end
  end
end
