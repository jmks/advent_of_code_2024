defmodule AdventOfCode2024.Day13Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day13

  @example """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  test "parse/1" do
    assert parse(@example) == [
             {{:a, {94, 34}}, {:b, {22, 67}}, {:prize, {8400, 5400}}},
             {{:a, {26, 66}}, {:b, {67, 21}}, {:prize, {12748, 12176}}},
             {{:a, {17, 86}}, {:b, {84, 37}}, {:prize, {7870, 6450}}},
             {{:a, {69, 23}}, {:b, {27, 71}}, {:prize, {18641, 10279}}}
           ]
  end

  test "min_winner/1" do
    assert min_winner({{:a, {94, 34}}, {:b, {22, 67}}, {:prize, {8400, 5400}}}) ==
             {:win, 80, 40, 280}

    assert min_winner({{:a, {26, 66}}, {:b, {67, 21}}, {:prize, {12748, 12176}}}) == :lose

    assert min_winner({{:a, {17, 86}}, {:b, {84, 37}}, {:prize, {7870, 6450}}}) ==
             {:win, 38, 86, 200}

    assert min_winner({{:a, {69, 23}}, {:b, {27, 71}}, {:prize, {18641, 10279}}}) == :lose
  end

  test "big_winner/1" do
    assert big_winner({{:a, {94, 34}}, {:b, {22, 67}}, {:prize, {8400, 5400}}}) == :lose

    assert big_winner({{:a, {26, 66}}, {:b, {67, 21}}, {:prize, {12748, 12176}}}) ==
             {:win, 118_679_050_709, 103_199_174_542, 459_236_326_669}

    assert big_winner({{:a, {17, 86}}, {:b, {84, 37}}, {:prize, {7870, 6450}}}) == :lose

    assert big_winner({{:a, {69, 23}}, {:b, {27, 71}}, {:prize, {18641, 10279}}}) ==
             {:win, 102_851_800_151, 107_526_881_786, 416_082_282_239}
  end
end
