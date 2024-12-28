defmodule AdventOfCode2024.Day15Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day15

  @example """
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
  """

  @smaller """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<
  """

  test "parse/1" do
    {map, moves} = parse(@example)

    assert {{0, 0}, :wall} in map
    assert {{3, 1}, :box} in map
    assert {{4, 4}, :robot} in map
    assert map.current == {4, 4}

    assert Enum.take(moves, 5) == [:left, :down, :down, :right, :up]
  end

  describe "move/2" do
    @initial """
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########
    """
    @step_2 """
    ########
    #.@O.O.#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########
    """
    @step_4 """
    ########
    #..@OO.#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########
    """
    @step_5 """
    ########
    #...@OO#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########
    """
    @step_6 """
    ########
    #....OO#
    ##..@..#
    #...O..#
    #.#.O..#
    #...O..#
    #...O..#
    ########
    """

    test "small example" do
      assert move(parse_map(@initial), :left) == parse_map(@initial)
      assert move(parse_map(@initial), :up) == parse_map(@step_2)
      assert move(parse_map(@step_2), :up) == parse_map(@step_2)
      assert move(parse_map(@step_2), :right) == parse_map(@step_4)
      assert move(parse_map(@step_4), :right) == parse_map(@step_5)
      assert move(parse_map(@step_5), :right) == parse_map(@step_5)
      assert move(parse_map(@step_5), :down) == parse_map(@step_6)
    end
  end

  describe "simulate/2" do
    test "smaller" do
      {map, moves} = parse(@smaller)
      final_map = simulate(map, moves)

      assert gps_sum(final_map) == 2028
    end

    test "example" do
      {map, moves} = parse(@example)
      final_map = simulate(map, moves)

      assert gps_sum(final_map) == 10092
    end
  end

  test "gps_sum/1" do
    map = """
    #######
    #...O..
    #......
    """

    assert gps_sum(parse_map(map)) == 104
  end
end
