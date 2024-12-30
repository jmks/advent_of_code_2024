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

  @double_example_final """
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
                        """
                        |> String.trim()

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

    test "pushes double-sized boxes" do
      initial = """
      ##############
      ##......##..##
      ##..........##
      ##....[][]@.##
      ##....[]....##
      ##..........##
      ##############
      """

      after_left = """
      ##############
      ##......##..##
      ##..........##
      ##...[][]@..##
      ##....[]....##
      ##..........##
      ##############
      """

      assert move(parse_map(initial), :left) == parse_map(after_left)
    end

    test "pushes single box up" do
      initial = """
      ####################
      ##....[]....[]..[]##
      ##............[]..##
      ##..[][]....[]..[]##
      ##...[].......[]..##
      ##[]##....[]......##
      ##[]......[]..[]..##
      ##..[][]..@[].[][]##
      ##........[]......##
      ####################
      """

      after_up = """
      ####################
      ##....[]....[]..[]##
      ##............[]..##
      ##..[][]....[]..[]##
      ##...[]...[]..[]..##
      ##[]##....[]......##
      ##[]......@...[]..##
      ##..[][]...[].[][]##
      ##........[]......##
      ####################
      """

      assert move(parse_map(initial), :up) == parse_map(after_up)
    end

    test "pushes multiple boxes up" do
      initial = """
      ##############
      ##......##..##
      ##..........##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##############
      """

      after_up = """
      ##############
      ##......##..##
      ##...[][]...##
      ##....[]....##
      ##.....@....##
      ##..........##
      ##############
      """

      assert move(parse_map(initial), :up) == parse_map(after_up)
      assert move(parse_map(after_up), :up) == parse_map(after_up)
    end

    test "pushes staggered boxes down" do
      initial = """
      ####################
      ##[]..[]......[][]##
      ##[]..[].......[].##
      ##[]..........[][]##
      ##..............[]##
      ##..##@...........##
      ##...[]...........##
      ##..[]..........[]##
      ##........[]......##
      ####################
      """

      after_down = """
      ####################
      ##[]..[]......[][]##
      ##[]..[].......[].##
      ##[]..........[][]##
      ##..............[]##
      ##..##............##
      ##....@...........##
      ##...[].........[]##
      ##..[]....[]......##
      ####################
      """

      assert move(parse_map(initial), :down) == parse_map(after_down), "Expected:\n#{after_down}\nBut got:\n#{visualize_map(move(parse_map(initial), :down))}"
    end

    test "does not move sibling boxes" do
      initial = """
      ##############
      ##......##..##
      ##...[][]...##
      ##...@[]....##
      ##..........##
      ##..........##
      ##############
      """

      after_up = """
      ##############
      ##...[].##..##
      ##...@.[]...##
      ##....[]....##
      ##..........##
      ##..........##
      ##############
      """

      assert move(parse_map(initial), :up) == parse_map(after_up)
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

    test "doubled example" do
      {map, moves} = parse_doubled(@example)

      final_map = simulate(map, moves)

      assert visualize_map(final_map) == @double_example_final
      assert gps_sum(final_map) == 9021
    end
  end

  describe "gps_sum/1" do
    test "single width box" do
      map = """
      #######
      #...O..
      #......
      """

      assert gps_sum(parse_map(map)) == 104
    end

    test "double with box" do
      map = """
      ##########
      ##...[]...
      ##........
      """

      assert gps_sum(parse_map(map)) == 105
    end

    test "double example" do
      assert gps_sum(parse_map(@double_example_final)) == 9021
    end
  end

  test "double_map/1" do
    output =
      """
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
      """
      |> String.trim()

    [original, _] = String.split(@example, "\n\n", parts: 2)

    assert double_map(original) == output
  end
end
