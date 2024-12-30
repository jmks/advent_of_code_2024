defmodule AdventOfCode2024.Day15 do
  @moduledoc """
  --- Day 15: Warehouse Woes ---

  You appear back inside your own mini submarine! Each Historian drives their mini submarine in a different direction; maybe the Chief has his own submarine down here somewhere as well?

  You look up to see a vast school of lanternfish swimming past you. On closer inspection, they seem quite anxious, so you drive your mini submarine over to see if you can help.

  Because lanternfish populations grow rapidly, they need a lot of food, and that food needs to be stored somewhere. That's why these lanternfish have built elaborate warehouse complexes operated by robots!

  These lanternfish seem so anxious because they have lost control of the robot that operates one of their most important warehouses! It is currently running amok, pushing around boxes in the warehouse with no regard for lanternfish logistics or lanternfish inventory management strategies.

  Right now, none of the lanternfish are brave enough to swim up to an unpredictable robot so they could shut it off. However, if you could anticipate the robot's movements, maybe they could find a safe option.

  The lanternfish already have a map of the warehouse and a list of movements the robot will attempt to make (your puzzle input). The problem is that the movements will sometimes fail as boxes are shifted around, making the actual movements of the robot difficult to predict.

  For example:

  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########

  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^

  As the robot (@) attempts to move, if there are any boxes (O) in the way, the robot will also attempt to push those boxes. However, if this action would cause the robot or a box to move into a wall (#), nothing moves instead, including the robot. The initial positions of these are shown on the map at the top of the document the lanternfish gave you.

  The rest of the document describes the moves (^ for up, v for down, < for left, > for right) that the robot will attempt to make, in order. (The moves form a single giant sequence; they are broken into multiple lines just to make copy-pasting easier. Newlines within the move sequence should be ignored.)

  Here is a smaller example to get started:

  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<

  Were the robot to attempt the given sequence of moves, it would push around the boxes as follows:

  Initial state:
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move <:
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move ^:
  ########
  #.@O.O.#
  ##..O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move ^:
  ########
  #.@O.O.#
  ##..O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move >:
  ########
  #..@OO.#
  ##..O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move >:
  ########
  #...@OO#
  ##..O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move >:
  ########
  #...@OO#
  ##..O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  Move v:
  ########
  #....OO#
  ##..@..#
  #...O..#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move v:
  ########
  #....OO#
  ##..@..#
  #...O..#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move <:
  ########
  #....OO#
  ##.@...#
  #...O..#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move v:
  ########
  #....OO#
  ##.....#
  #..@O..#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move >:
  ########
  #....OO#
  ##.....#
  #...@O.#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move >:
  ########
  #....OO#
  ##.....#
  #....@O#
  #.#.O..#
  #...O..#
  #...O..#
  ########

  Move v:
  ########
  #....OO#
  ##.....#
  #.....O#
  #.#.O@.#
  #...O..#
  #...O..#
  ########

  Move <:
  ########
  #....OO#
  ##.....#
  #.....O#
  #.#O@..#
  #...O..#
  #...O..#
  ########

  Move <:
  ########
  #....OO#
  ##.....#
  #.....O#
  #.#O@..#
  #...O..#
  #...O..#
  ########

  The larger example has many more moves; after the robot has finished those moves, the warehouse would look like this:

  ##########
  #.O.O.OOO#
  #........#
  #OO......#
  #OO@.....#
  #O#.....O#
  #O.....OO#
  #O.....OO#
  #OO....OO#
  ##########

  The lanternfish use their own custom Goods Positioning System (GPS for short) to track the locations of the boxes. The GPS coordinate of a box is equal to 100 times its distance from the top edge of the map plus its distance from the left edge of the map. (This process does not stop at wall tiles; measure all the way to the edges of the map.)

  So, the box shown below has a distance of 1 from the top edge of the map and 4 from the left edge of the map, resulting in a GPS coordinate of 100 * 1 + 4 = 104.

  #######
  #...O..
  #......

  The lanternfish would like to know the sum of all boxes' GPS coordinates after the robot finishes moving. In the larger example, the sum of all boxes' GPS coordinates is 10092. In the smaller example, the sum is 2028.

  Predict the motion of the robot and boxes in the warehouse. After the robot is finished moving, what is the sum of all boxes' GPS coordinates?

  --- Part Two ---

  The lanternfish use your information to find a safe moment to swim in and turn off the malfunctioning robot! Just as they start preparing a festival in your honor, reports start coming in that a second warehouse's robot is also malfunctioning.

  This warehouse's layout is surprisingly similar to the one you just helped. There is one key difference: everything except the robot is twice as wide! The robot's list of movements doesn't change.

  To get the wider warehouse's map, start with your original map and, for each tile, make the following changes:

      If the tile is #, the new map contains ## instead.
      If the tile is O, the new map contains [] instead.
      If the tile is ., the new map contains .. instead.
      If the tile is @, the new map contains @. instead.

  This will produce a new warehouse map which is twice as wide and with wide boxes that are represented by []. (The robot does not change size.)

  The larger example from before would now look like this:

  ####################
  ##....[]....[]..[]##
  ##............[]..##
  ##..[][]....[]..[]##
  ##....[]@.....[]..##
  ##[]##....[]......##
  ##[]....[]....[]..##
  ##..[][]..[]..[][]##
  ##........[]......##
  ####################

  Because boxes are now twice as wide but the robot is still the same size and speed, boxes can be aligned such that they directly push two other boxes at once. For example, consider this situation:

  #######
  #...#.#
  #.....#
  #..OO@#
  #..O..#
  #.....#
  #######

  <vv<<^^<<^^

  After appropriately resizing this map, the robot would push around these boxes as follows:

  Initial state:
  ##############
  ##......##..##
  ##..........##
  ##....[][]@.##
  ##....[]....##
  ##..........##
  ##############

  Move <:
  ##############
  ##......##..##
  ##..........##
  ##...[][]@..##
  ##....[]....##
  ##..........##
  ##############

  Move v:
  ##############
  ##......##..##
  ##..........##
  ##...[][]...##
  ##....[].@..##
  ##..........##
  ##############

  Move v:
  ##############
  ##......##..##
  ##..........##
  ##...[][]...##
  ##....[]....##
  ##.......@..##
  ##############

  Move <:
  ##############
  ##......##..##
  ##..........##
  ##...[][]...##
  ##....[]....##
  ##......@...##
  ##############

  Move <:
  ##############
  ##......##..##
  ##..........##
  ##...[][]...##
  ##....[]....##
  ##.....@....##
  ##############

  Move ^:
  ##############
  ##......##..##
  ##...[][]...##
  ##....[]....##
  ##.....@....##
  ##..........##
  ##############

  Move ^:
  ##############
  ##......##..##
  ##...[][]...##
  ##....[]....##
  ##.....@....##
  ##..........##
  ##############

  Move <:
  ##############
  ##......##..##
  ##...[][]...##
  ##....[]....##
  ##....@.....##
  ##..........##
  ##############

  Move <:
  ##############
  ##......##..##
  ##...[][]...##
  ##....[]....##
  ##...@......##
  ##..........##
  ##############

  Move ^:
  ##############
  ##......##..##
  ##...[][]...##
  ##...@[]....##
  ##..........##
  ##..........##
  ##############

  Move ^:
  ##############
  ##...[].##..##
  ##...@.[]...##
  ##....[]....##
  ##..........##
  ##..........##
  ##############

  This warehouse also uses GPS to locate the boxes. For these larger boxes, distances are measured from the edge of the map to the closest edge of the box in question. So, the box shown below has a distance of 1 from the top edge of the map and 5 from the left edge of the map, resulting in a GPS coordinate of 100 * 1 + 5 = 105.

  ##########
  ##...[]...
  ##........

  In the scaled-up version of the larger example from above, after the robot has finished all of its moves, the warehouse would look like this:

  ####################
  ##[].......[].[][]##
  ##[]...........[].##
  ##[]........[][][]##
  ##[]......[]....[]##
  ##..##......[]....##
  ##..[]............##
  ##..@......[].[][]##
  ##......[][]..[]..##
  ####################

  The sum of these boxes' GPS coordinates is 9021.

  Predict the motion of the robot and boxes in this new, scaled-up warehouse. What is the sum of all boxes' final GPS coordinates?
  """
  def part1 do
    {map, moves} = parse(Inputs.binary(15))

    final_map = simulate(map, moves)

    gps_sum(final_map)
  end

  def part2 do
    {map, moves} = parse_doubled(Inputs.binary(15))

    final_map = simulate(map, moves)

    gps_sum(final_map)
  end

  def parse(input) do
    [grid, moves] = String.split(input, "\n\n", parts: 2)

    {parse_map(grid), parse_moves(moves)}
  end

  def parse_doubled(input) do
    [original_map, original_moves] = String.split(input, "\n\n", parts: 2)

    map = original_map |> double_map() |> parse_map()
    moves = parse_moves(original_moves)

    {map, moves}
  end

  def parse_map(map) do
    map
    |> String.trim()
    |> String.split("\n", trim: true)
    |> AdventOfCode2024.Parsers.Tiles.as_map(fn
      "#" -> {:ok, :wall}
      "O" -> {:ok, :box}
      "[" -> {:ok, :box_left}
      "]" -> {:ok, :box_right}
      "@" -> {:current, :robot}
      "." -> {:ok, :open}
    end)
  end

  def move(map, direction) when direction in [:left, :right] do
    map
    |> travel_along(direction)
    |> move_tiles(map)
  end

  def move(map, direction) when direction in [:up, :down] do
    case moving_coordinates(map.current, direction, map) do
      {:ok, coordinates} ->
        move_tiles(map, coordinates, direction)

      :wall ->
        map
    end
  end

  def visualize_map(map) do
    for y <- 0..(map.y_max - 1) do
      for x <- 0..(map.x_max - 1) do
        case Map.get(map.tiles, {x, y}) do
          :wall -> "#"
          :robot -> "@"
          :box -> "O"
          :box_left -> "["
          :box_right -> "]"
          :open -> "."
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def simulate(map, moves) do
    Enum.reduce(moves, map, &move(&2, &1))
  end

  def gps_sum(map) do
    map.tiles
    |> Enum.map(fn
      {{x, y}, :box} -> x + 100 * y
      {{x, y}, :box_left} -> x + 100 * y
      _ -> 0
    end)
    |> Enum.sum()
  end

  defp moving_coordinates(start, direction, map) do
    do_moving_coordinates([start], direction, map, MapSet.new())
  end

  defp do_moving_coordinates([], _dir, _map, moved), do: {:ok, moved}

  defp do_moving_coordinates(frontier, dir, map, moved) do
    new_frontier =
      Enum.reduce_while(frontier, [], fn coord, acc ->
        next_coord = adjacent(coord, dir)

        case Map.get(map.tiles, next_coord) do
          :wall -> {:halt, :wall}
          :open -> {:cont, acc}
          :box -> {:cont, [next_coord | acc]}
          :box_left -> {:cont, [next_coord, adjacent(next_coord, :right) | acc]}
          :box_right -> {:cont, [next_coord, adjacent(next_coord, :left) | acc]}
        end
      end)

    if new_frontier == :wall do
      :wall
    else
      new_frontier = Enum.reject(new_frontier, &(&1 in moved))
      new_moved = MapSet.union(moved, MapSet.new(frontier))

      do_moving_coordinates(new_frontier, dir, map, new_moved)
    end
  end

  defp travel_along(map, direction) do
    next_coord = adjacent(map.current, direction)
    next_value = Map.get(map.tiles, next_coord)

    do_travel_along({next_value, next_coord}, map.current, direction, map, [{map.current, :open}])
  end

  def double_map(grid) do
    grid
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.map(fn
        "#" -> "##"
        "O" -> "[]"
        "." -> ".."
        "@" -> "@."
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  defp do_travel_along({:wall, _}, _from, _dir, _map, _moves), do: []

  defp do_travel_along({:open, to}, from, _dir, _map, moves) do
    [{from, to} | moves]
  end

  defp do_travel_along({box, to}, from, dir, map, moves)
       when box in [:box, :box_left, :box_right] do
    next_coord = adjacent(to, dir)
    next_value = Map.get(map.tiles, next_coord)

    do_travel_along({next_value, next_coord}, to, dir, map, [{from, to} | moves])
  end

  defp adjacent({x, y}, :left), do: {x - 1, y}
  defp adjacent({x, y}, :right), do: {x + 1, y}
  defp adjacent({x, y}, :up), do: {x, y - 1}
  defp adjacent({x, y}, :down), do: {x, y + 1}

  defp move_tiles(moves, map) do
    Enum.reduce(moves, map, fn
      {from, :open}, map ->
        %{map | tiles: Map.put(map.tiles, from, :open)}

      {from, to}, map ->
        new_value = Map.get(map.tiles, from)

        if new_value == :robot do
          %{map | current: to, tiles: Map.put(map.tiles, to, new_value)}
        else
          %{map | tiles: Map.put(map.tiles, to, new_value)}
        end
    end)
  end

  defp move_tiles(map, tiles, direction) do
    cleared_tiles =
      Enum.reduce(tiles, map.tiles, fn tile, acc ->
        Map.put(acc, tile, :open)
      end)
    cleared_map = %{map | tiles: cleared_tiles}

    Enum.reduce(tiles, cleared_map, fn coordinate, acc ->
      new_coordinate = adjacent(coordinate, direction)
      old_value = Map.get(map.tiles, coordinate)

      new_tiles = Map.put(acc.tiles, new_coordinate, old_value)

      if old_value == :robot do
        %{acc | current: new_coordinate, tiles: new_tiles}
      else
        %{acc | tiles: new_tiles}
      end
    end)
  end

  defp parse_moves(moves) do
    moves
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.codepoints/1)
    |> Enum.map(&parse_move/1)
  end

  defp parse_move(move) do
    case move do
      "<" -> :left
      ">" -> :right
      "^" -> :up
      "v" -> :down
    end
  end
end
