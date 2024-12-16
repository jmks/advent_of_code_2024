defmodule AdventOfCode2024.Day08 do
  @moduledoc """
  --- Day 8: Resonant Collinearity ---

  You find yourselves on the roof of a top-secret Easter Bunny installation.

  While The Historians do their thing, you take a look at the familiar huge antenna. Much to your surprise, it seems to have been reconfigured to emit a signal that makes people 0.1% more likely to buy Easter Bunny brand Imitation Mediocre Chocolate as a Christmas gift! Unthinkable!

  Scanning across the city, you find that there are actually many such antennas. Each antenna is tuned to a specific frequency indicated by a single lowercase letter, uppercase letter, or digit. You create a map (your puzzle input) of these antennas. For example:

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

  The signal only applies its nefarious effect at specific antinodes based on the resonant frequencies of the antennas. In particular, an antinode occurs at any point that is perfectly in line with two antennas of the same frequency - but only when one of the antennas is twice as far away as the other. This means that for any pair of antennas with the same frequency, there are two antinodes, one on either side of them.

  So, for these two antennas with frequency a, they create the two antinodes marked with #:

  ..........
  ...#......
  ..........
  ....a.....
  ..........
  .....a....
  ..........
  ......#...
  ..........
  ..........

  Adding a third antenna with the same frequency creates several more antinodes. It would ideally add four antinodes, but two are off the right side of the map, so instead it adds only two:

  ..........
  ...#......
  #.........
  ....a.....
  ........a.
  .....a....
  ..#.......
  ......#...
  ..........
  ..........

  Antennas with different frequencies don't create antinodes; A and a count as different frequencies. However, antinodes can occur at locations that contain antennas. In this diagram, the lone antenna with frequency capital A creates no antinodes but has a lowercase-a-frequency antinode at its location:

  ..........
  ...#......
  #.........
  ....a.....
  ........a.
  .....a....
  ..#.......
  ......A...
  ..........
  ..........

  The first example has antennas with two different frequencies, so the antinodes they create look like this, plus an antinode overlapping the topmost A-frequency antenna:

  ......#....#
  ...#....0...
  ....#0....#.
  ..#....0....
  ....0....#..
  .#....A.....
  ...#........
  #......#....
  ........A...
  .........A..
  ..........#.
  ..........#.

  Because the topmost A-frequency antenna overlaps with a 0-frequency antinode, there are 14 total unique locations that contain an antinode within the bounds of the map.

  Calculate the impact of the signal. How many unique locations within the bounds of the map contain an antinode?

  --- Part Two ---

  Watching over your shoulder as you work, one of The Historians asks if you took the effects of resonant harmonics into your calculations.

  Whoops!

  After updating your model, it turns out that an antinode occurs at any grid position exactly in line with at least two antennas of the same frequency, regardless of distance. This means that some of the new antinodes will occur at the position of each antenna (unless that antenna is the only one of its frequency).

  So, these three T-frequency antennas now create many antinodes:

  T....#....
  ...T......
  .T....#...
  .........#
  ..#.......
  ..........
  ...#......
  ..........
  ....#.....
  ..........

  In fact, the three T-frequency antennas are all exactly in line with two antennas, so they are all also antinodes! This brings the total number of antinodes in the above example to 9.

  The original example now has 34 antinodes, including the antinodes that appear on every antenna:

  ##....#....#
  .#.#....0...
  ..#.#0....#.
  ..##...0....
  ....0....#..
  .#...#A....#
  ...#..#.....
  #....#.#....
  ..#.....A...
  ....#....A..
  .#........#.
  ...#......##

  Calculate the impact of the signal using this updated model. How many unique locations within the bounds of the map contain an antinode?
  """

  def part1 do
    Inputs.lines(8, :binary)
    |> parse()
    |> unique_locations_with_antinodes()
    |> length()
  end

  def part2 do
    Inputs.lines(8, :binary)
    |> parse()
    |> unique_locations_with_antinodes(&antinodes_with_harmonics/4)
    |> length()
  end

  def parse(map) do
    AdventOfCode2024.Parsers.Tiles.parse(map, & &1)
  end

  def antinodes({x1, y1}, {x2, y2}, x_range, y_range) do
    rise = y2 - y1
    run = x2 - x1

    [{x1 - run, y1 - rise}, {x2 + run, y2 + rise}]
    |> Enum.filter(fn {x, y} -> x in x_range and y in y_range end)
  end

  def antinodes_with_harmonics({x1, y1}, {x2, y2}, x_range, y_range) do
    rise = y2 - y1
    run = x2 - x1

    travel_along({x1, y1}, {run, rise}, :sub, x_range, y_range, []) ++
      travel_along({x2, y2}, {run, rise}, :add, x_range, y_range, [])
  end

  defp travel_along({x, y}, {run, rise}, op, x_range, y_range, acc) do
    if x in x_range and y in y_range do
      new_point =
        case op do
          :sub -> {x - run, y - rise}
          :add -> {x + run, y + rise}
        end

      travel_along(new_point, {run, rise}, op, x_range, y_range, [{x, y} | acc])
    else
      Enum.sort(acc, :asc)
    end
  end

  def unique_locations_with_antinodes(tiles, antinode_fun \\ &antinodes/4) do
    {x_min, x_max} = tiles |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max()
    {y_min, y_max} = tiles |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()

    node_groups =
      tiles
      |> Enum.reject(fn {_, value} -> value == "." end)
      |> Enum.group_by(fn {_, value} -> value end)

    node_groups
    |> Map.keys()
    |> Enum.map(fn node ->
      Map.fetch!(node_groups, node)
      |> pairwise()
      |> Enum.map(fn {{left, _}, {right, _}} ->
        antinode_fun.(left, right, x_min..x_max, y_min..y_max)
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def pairwise(things) when length(things) < 2, do: []

  def pairwise(things) do
    do_pairwise(things, [])
  end

  defp do_pairwise([_], acc) do
    acc |> Enum.reverse() |> List.flatten()
  end

  defp do_pairwise([x | rest], acc) do
    pairs = for r <- rest, do: {x, r}

    do_pairwise(rest, [pairs, acc])
  end
end
