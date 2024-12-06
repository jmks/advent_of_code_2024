defmodule AdventOfCode2024.Day01Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day01

  @example [
    [3, 4],
    [4, 3],
    [2, 5],
    [1, 3],
    [3, 9],
    [3, 3]
  ]

  describe "smallwise_pair_difference/1" do
    test "example" do
      assert smallwise_pair_difference(@example) == 11
    end
  end
end
