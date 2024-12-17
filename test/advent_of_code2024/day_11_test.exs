defmodule AdventOfCode2024.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day11

  describe "blink/1" do
    test "small example" do
      assert blink([0, 1, 10, 99, 999]) == [1, 2024, 1, 0, 9, 9, 2_021_976]
    end

    test "repeated steps" do
      stones = [125, 17]

      assert stones |> blink() == [253_000, 1, 7]
      assert stones |> blink() |> blink() == [253, 0, 2024, 14168]
      assert stones |> blink() |> blink() |> blink() == [512_072, 1, 20, 24, 28_676_032]

      assert stones |> blink() |> blink() |> blink() |> blink() == [
               512,
               72,
               2024,
               2,
               0,
               2,
               4,
               2867,
               6032
             ]

      assert stones |> blink() |> blink() |> blink() |> blink() |> blink() == [
               1_036_288,
               7,
               2,
               20,
               24,
               4048,
               1,
               4048,
               8096,
               28,
               67,
               60,
               32
             ]
    end
  end

  describe "total_stones/2" do
    test "after many blinks" do
      stones = [125, 17]

      assert total_stones(stones, 25) == 55312
    end
  end
end
