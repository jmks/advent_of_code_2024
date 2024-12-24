defmodule AdventOfCode2024.Day14Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day14

  @example """
           p=0,4 v=3,-3
           p=6,3 v=-1,-3
           p=10,3 v=-1,2
           p=2,0 v=2,-1
           p=0,0 v=1,3
           p=3,0 v=-2,-2
           p=7,6 v=-1,-3
           p=3,0 v=-1,-2
           p=9,3 v=2,3
           p=7,3 v=-1,2
           p=2,4 v=2,-3
           p=9,5 v=-3,-3
           """
           |> String.split("\n", trim: true)

  test "parse/1" do
    parsed = parse(@example)

    assert {{:pos, 0, 4}, {:vel, 3, -3}} in parsed
    assert {{:pos, 6, 3}, {:vel, -1, -3}} in parsed
    assert {{:pos, 9, 5}, {:vel, -3, -3}} in parsed
  end

  describe "step/2" do
    test "example robot" do
      assert step({{:pos, 2, 4}, {:vel, 2, -3}}, {11, 7}) == {{:pos, 4, 1}, {:vel, 2, -3}}
      assert step({{:pos, 4, 1}, {:vel, 2, -3}}, {11, 7}) == {{:pos, 6, 5}, {:vel, 2, -3}}
      assert step({{:pos, 6, 5}, {:vel, 2, -3}}, {11, 7}) == {{:pos, 8, 2}, {:vel, 2, -3}}
      assert step({{:pos, 8, 2}, {:vel, 2, -3}}, {11, 7}) == {{:pos, 10, 6}, {:vel, 2, -3}}
      assert step({{:pos, 10, 6}, {:vel, 2, -3}}, {11, 7}) == {{:pos, 1, 3}, {:vel, 2, -3}}
    end
  end

  describe "quadrant/2" do
    test "four quadrants" do
      assert quadrant({{:pos, 0, 2}, {}}, {11, 7}) == 1
      assert quadrant({{:pos, 1, 10}, {}}, {11, 7}) == 2
      assert quadrant({{:pos, 9, 0}, {}}, {11, 7}) == 3
      assert quadrant({{:pos, 6, 10}, {}}, {11, 7}) == 4
    end

    test "coordinates on midline are not assigned quadrants" do
      assert quadrant({{:pos, 5, 4}, {}}, {11, 7}) == nil
      assert quadrant({{:pos, 1, 3}, {}}, {11, 7}) == nil
    end
  end

  describe "safety_factor/3" do
    test "example" do
      assert safety_factor(parse(@example), {11, 7}, 100) == 12
    end
  end
end
