defmodule AdventOfCode2024.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day11

  describe "blink/1" do
    test "small example" do
      assert blink([0, 1, 10, 99, 999]) == [1, 2024, 1, 0, 9, 9, 2_021_976]
    end
  end

  describe "blinks/2" do
    test "many blinks" do
      stones = [125, 17]

      assert blinks(stones, 1) == [253_000, 1, 7]
      assert blinks(stones, 2) == [253, 0, 2024, 14168]
      assert blinks(stones, 3) == [512_072, 1, 20, 24, 28_676_032]
      assert blinks(stones, 4) == [512, 72, 2024, 2, 0, 2, 4, 2867, 6032]
      assert blinks(stones, 5) == [1_036_288, 7, 2, 20, 24, 4048, 1, 4048, 8096, 28, 67, 60, 32]

      assert blinks(stones, 6) == [
               2_097_446_912,
               14168,
               4048,
               2,
               0,
               2,
               4,
               40,
               48,
               2024,
               40,
               48,
               80,
               96,
               2,
               8,
               6,
               7,
               6,
               0,
               3,
               2
             ]

      assert length(blinks(stones, 25)) == 55312
    end
  end
end
