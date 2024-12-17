defmodule AdventOfCode2024.Day10Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day10

  @example """
           0123
           1234
           8765
           9876
           """
           |> String.trim()
           |> String.split("\n", trim: true)

  test "parse/1" do
    parsed = parse(@example)

    assert {{0, 0}, 0} in parsed
    assert {{0, 1}, 1} in parsed
    assert {{0, 2}, 2} in parsed
    assert {{0, 3}, 3} in parsed
    assert {{3, 2}, 7} in parsed
  end

  describe "trails/1" do
    test "finds all paths" do
      topo =
        parse(
          map("""
          0123
          1234
          8765
          9876
          """)
        )

      paths = trails(topo, {0, 0})

      assert [{0, 0}, {1, 0}, {1, 1}, {1, 2}, {1, 3}, {2, 3}, {3, 3}, {3, 2}, {3, 1}, {3, 0}] in paths
      assert length(paths) == 16
    end
  end

  describe "score/1" do
    test "big example" do
      topo =
        """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """
        |> map()
        |> parse()

      assert score(topo) == 36
    end
  end

  describe "rating/1" do
    test "many distinct paths" do
      topo =
        """
        012345
        123456
        234567
        345678
        406789
        567890
        """
        |> map()
        |> parse()

      assert rating(topo) == 227
    end

    test "larger map, fewer distinct paths" do
      topo =
        """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """
        |> map()
        |> parse()

      assert rating(topo) == 81
    end
  end

  defp map(str) do
    str |> String.trim() |> String.split("\n", trim: true)
  end
end
