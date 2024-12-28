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
  """
  def part1 do
    {map, moves} = parse(Inputs.binary(15))

    final_map = simulate(map, moves)

    gps_sum(final_map)
  end

  def part2 do
  end

  def parse(input) do
    [grid, moves] = String.split(input, "\n\n", parts: 2)

    {parse_map(grid), parse_moves(moves)}
  end

  def parse_map(map) do
    map
    |> String.trim()
    |> String.split("\n", trim: true)
    |> AdventOfCode2024.Parsers.Tiles.as_map(fn
      "#" -> {:ok, :wall}
      "O" -> {:ok, :box}
      "@" -> {:current, :robot}
      "." -> {:ok, :open}
    end)
  end

  def move(map, direction) do
    map
    |> travel_along(direction)
    |> move_tiles(map)
  end

  def simulate(map, moves) do
    Enum.reduce(moves, map, &move(&2, &1))
  end

  def gps_sum(map) do
    map.tiles
    |> Enum.filter(&match?({_, :box}, &1))
    |> Enum.map(fn {{x, y}, :box} -> x + 100 * y end)
    |> Enum.sum()
  end

  defp travel_along(map, direction) do
    next_coord = adjacent(map.current, direction)
    next_value = Map.get(map.tiles, next_coord)

    do_travel_along({next_value, next_coord}, map.current, direction, map, [{map.current, :open}])
  end

  defp do_travel_along({:wall, _}, _from, _dir, _map, _moves), do: []

  defp do_travel_along({:open, to}, from, _dir, _map, moves) do
    [{from, to} | moves]
  end

  defp do_travel_along({:box, to}, from, dir, map, moves) do
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
