defmodule AdventOfCode2024.Day06 do
  @moduledoc """
    --- Day 6: Guard Gallivant ---

    The Historians use their fancy device again, this time to whisk you all away to the North Pole prototype suit manufacturing lab... in the year 1518! It turns out that having direct access to history is very convenient for a group of historians.

    You still have to be careful of time paradoxes, and so it will be important to avoid anyone from 1518 while The Historians search for the Chief. Unfortunately, a single guard is patrolling this part of the lab.

    Maybe you can work out where the guard will go ahead of time so that The Historians can search safely?

    You start by making a map (your puzzle input) of the situation. For example:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...

    The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.

    Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:

        If there is something directly in front of you, turn right 90 degrees.
        Otherwise, take a step forward.

    Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

    ....#.....
    ....^....#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

    Because there is now an obstacle in front of the guard, she turns right before continuing straight in her new facing direction:

    ....#.....
    ........>#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

    Reaching another obstacle (a spool of several very long polymers), she turns right again and continues downward:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#......v.
    ........#.
    #.........
    ......#...

    This process continues for a while, but the guard eventually leaves the mapped area (after walking past a tank of universal solvent):

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#v..

    By predicting the guard's route, you can determine which specific positions in the lab will be in the patrol path. Including the guard's starting position, the positions visited by the guard before leaving the area are marked with an X:

    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ..XXXXX#X.
    ..X.X.X.X.
    .#XXXXXXX.
    .XXXXXXX#.
    #XXXXXXX..
    ......#X..

    In this example, the guard will visit 41 distinct positions on your map.

    Predict the path of the guard. How many distinct positions will the guard visit before leaving the mapped area?
  """
  def part1 do
    Inputs.lines(6, :binary)
    |> parse()
    |> guard_visited()
    |> MapSet.size()
  end

  def part2 do
  end

  def parse(map) do
    map
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {tile, column} ->
        {{row, column}, tile_type(tile)}
      end)
    end)
  end

  def guard_visited(tiles) do
    {coord, _} = start = Enum.find(tiles, &match?({_coord, {:guard, _}}, &1))

    map =
      tiles
      |> Enum.into(Map.new())
      |> Map.put(coord, :open)

    visit(start, map, MapSet.new())
  end

  defp tile_type("."), do: :open
  defp tile_type("#"), do: :obstacle
  defp tile_type(">"), do: {:guard, :right}
  defp tile_type("<"), do: {:guard, :left}
  defp tile_type("^"), do: {:guard, :up}
  defp tile_type("v"), do: {:guard, :down}

  defp visit({coord, {:guard, dir}}, map, visited) do
    new_visited = MapSet.put(visited, coord)
    new_coord = step_forward(dir, coord)
    new_tile = Map.get(map, new_coord)

    case new_tile do
      :open ->
        visit({new_coord, {:guard, dir}}, map, new_visited)

      :obstacle ->
        new_dir = turn_right(dir)
        new_coord = step_forward(new_dir, coord)

        visit({new_coord, {:guard, new_dir}}, map, new_visited)

      nil ->
        new_visited
    end
  end

  defp step_forward(:left, {row, col}), do: {row, col - 1}
  defp step_forward(:right, {row, col}), do: {row, col + 1}
  defp step_forward(:up, {row, col}), do: {row - 1, col}
  defp step_forward(:down, {row, col}), do: {row + 1, col}

  defp turn_right(:up), do: :right
  defp turn_right(:left), do: :up
  defp turn_right(:down), do: :left
  defp turn_right(:right), do: :down
end
