defmodule AdventOfCode2024.Day14 do
  @moduledoc """
  --- Day 14: Restroom Redoubt ---

  One of The Historians needs to use the bathroom; fortunately, you know there's a bathroom near an unvisited location on their list, and so you're all quickly teleported directly to the lobby of Easter Bunny Headquarters.

  Unfortunately, EBHQ seems to have "improved" bathroom security again after your last visit. The area outside the bathroom is swarming with robots!

  To get The Historian safely to the bathroom, you'll need a way to predict where the robots will be in the future. Fortunately, they all seem to be moving on the tile floor in predictable straight lines.

  You make a list (your puzzle input) of all of the robots' current positions (p) and velocities (v), one robot per line. For example:

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

  Each robot's position is given as p=x,y where x represents the number of tiles the robot is from the left wall and y represents the number of tiles from the top wall (when viewed from above). So, a position of p=0,0 means the robot is all the way in the top-left corner.

  Each robot's velocity is given as v=x,y where x and y are given in tiles per second. Positive x means the robot is moving to the right, and positive y means the robot is moving down. So, a velocity of v=1,-2 means that each second, the robot moves 1 tile to the right and 2 tiles up.

  The robots outside the actual bathroom are in a space which is 101 tiles wide and 103 tiles tall (when viewed from above). However, in this example, the robots are in a space which is only 11 tiles wide and 7 tiles tall.

  The robots are good at navigating over/under each other (due to a combination of springs, extendable legs, and quadcopters), so they can share the same tile and don't interact with each other. Visually, the number of robots on each tile in this example looks like this:

  1.12.......
  ...........
  ...........
  ......11.11
  1.1........
  .........1.
  .......1...

  These robots have a unique feature for maximum bathroom security: they can teleport. When a robot would run into an edge of the space they're in, they instead teleport to the other side, effectively wrapping around the edges. Here is what robot p=2,4 v=2,-3 does for the first few seconds:

  Initial state:
  ...........
  ...........
  ...........
  ...........
  ..1........
  ...........
  ...........

  After 1 second:
  ...........
  ....1......
  ...........
  ...........
  ...........
  ...........
  ...........

  After 2 seconds:
  ...........
  ...........
  ...........
  ...........
  ...........
  ......1....
  ...........

  After 3 seconds:
  ...........
  ...........
  ........1..
  ...........
  ...........
  ...........
  ...........

  After 4 seconds:
  ...........
  ...........
  ...........
  ...........
  ...........
  ...........
  ..........1

  After 5 seconds:
  ...........
  ...........
  ...........
  .1.........
  ...........
  ...........
  ...........

  The Historian can't wait much longer, so you don't have to simulate the robots for very long. Where will the robots be after 100 seconds?

  In the above example, the number of robots on each tile after 100 seconds has elapsed looks like this:

  ......2..1.
  ...........
  1..........
  .11........
  .....1.....
  ...12......
  .1....1....

  To determine the safest area, count the number of robots in each quadrant after 100 seconds. Robots that are exactly in the middle (horizontally or vertically) don't count as being in any quadrant, so the only relevant robots are:

  ..... 2..1.
  ..... .....
  1.... .....

  ..... .....
  ...12 .....
  .1... 1....

  In this example, the quadrants contain 1, 3, 4, and 1 robot. Multiplying these together gives a total safety factor of 12.

  Predict the motion of the robots in your list within a space which is 101 tiles wide and 103 tiles tall. What will the safety factor be after exactly 100 seconds have elapsed?
  """
  def part1 do
    Inputs.lines(14, :binary)
    |> parse()
    |> safety_factor({101, 103}, 100)
  end

  def part2 do
  end

  def parse(input) do
    Enum.map(input, fn line ->
      [pos, vel] = String.split(line, " ", trim: true, parts: 2)

      {parse_vector(pos), parse_vector(vel)}
    end)
  end

  def step({{:pos, x, y}, {:vel, vx, vy} = velocity}, {width, height}) do
    new_x = move(x, vx, width)
    new_y = move(y, vy, height)

    {{:pos, new_x, new_y}, velocity}
  end

  def safety_factor(robots, grid_size, steps)

  def safety_factor(robots, grid_size, 0) do
    robots
    |> Enum.map(&quadrant(&1, grid_size))
    |> Enum.frequencies()
    |> Map.delete(nil)
    |> Map.values()
    |> Enum.reduce(&Kernel.*/2)
  end

  def safety_factor(robots, grid_size, steps) do
    robots
    |> Enum.map(&step(&1, grid_size))
    |> safety_factor(grid_size, steps - 1)
  end

  def quadrant({{:pos, x, y}, _vel}, {width, height}) do
    case {integer_compare(x, div(width, 2)), integer_compare(y, div(height, 2))} do
      {:eq, _} -> nil
      {_, :eq} -> nil
      {:lt, :lt} -> 1
      {:lt, :gt} -> 2
      {:gt, :lt} -> 3
      {:gt, :gt} -> 4
    end
  end

  defp visualize(robots, {width, height}) do
    IO.puts("Robot Locations:")
    counts =
      robots
      |> Enum.map(fn {{:pos, x, y}, _vel} -> {x, y} end)
      |> Enum.frequencies()

    for y <- 0..(height - 1) do
      row = for x <- 0..(width - 1) do
        Map.get(counts, {x, y}, ".")
      end |> Enum.join("")

      IO.puts(row)
    end

    robots
  end

  defp integer_compare(a, b) when a < b, do: :lt
  defp integer_compare(a, b) when a > b, do: :gt
  defp integer_compare(a, a), do: :eq

  defp parse_vector("p=" <> values) do
    values
    |> parse_values()
    |> then(fn [x, y] -> {:pos, x, y} end)
  end

  defp parse_vector("v=" <> values) do
    values
    |> parse_values()
    |> then(fn [x, y] -> {:vel, x, y} end)
  end

  defp parse_values(values) do
    values
    |> String.split(",", trim: true, parts: 2)
    |> Enum.map(&String.to_integer/1)
  end

  defp move(p, v, max) do
    np = rem(p + v, max)

    if np < 0 do
      np + max
    else
      np
    end
  end
end
