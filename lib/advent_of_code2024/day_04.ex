defmodule AdventOfCode2024.Day04 do
  @moduledoc """
    --- Day 4: Ceres Search ---

    "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

    As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

    This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

    ..X...
    .SAMX.
    .A..A.
    XMAS.S
    .X....

    The actual word search will be full of letters instead. For example:

    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX

    In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

    ....XXMAS.
    .SAMXMS...
    ...S..A...
    ..A.A.MS.X
    XMASAMX.MM
    X.....XA.A
    S.S.S.S.SS
    .A.A.A.A.A
    ..M.M.M.MM
    .X.X.XMASX

    Take a look at the little Elf's word search. How many times does XMAS appear?

    --- Part Two ---

    The Elf looks quizzically at you. Did you misunderstand the assignment?

    Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

    M.S
    .A.
    M.S

    Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

    Here's the same example from before, but this time all of the X-MASes have been kept instead:

    .M.S......
    ..A..MSMS.
    .M.S.MAA..
    ..A.ASMSM.
    .M.S.M....
    ..........
    S.S.S.S.S.
    .A.A.A.A..
    M.M.M.M.M.
    ..........

    In this example, an X-MAS appears 9 times.

    Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
  """
  # Brunte force.
  # Graph seach? Find paths X -> M -> A -> S
  def search(word_search) do
    horizontal(word_search) +
      vertical(word_search) +
      diagonal(word_search)
  end

  # Find MAS in an X pattern:
  #
  # M.S  S.S  S.M  M.M
  # .A.  .A.  .A.  .A.
  # M.S  M.M  S.M  S.S
  def x_mas_search(word_search) do
    {targets, grid} = build_grid(word_search)

    targets
    |> Enum.filter(&x_mas?(&1, grid))
    |> length()
  end

  defp horizontal(word_search) do
    Enum.reduce(word_search, 0, fn line, acc ->
      acc + count_xmas(line)
    end)
  end

  defp vertical(word_search) do
    word_search
    |> transpose()
    |> horizontal()
  end

  defp transpose(word_search) do
    word_search
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join(&1, ""))
  end

  defp diagonal(word_search) do
    word_search
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.flat_map(fn chunk -> [shift(chunk, :left), shift(chunk, :right)] end)
    |> Enum.map(&vertical/1)
    |> Enum.sum()
  end

  defp shift([one, two, three, four], dir) do
    [
      one,
      shift_string(two, 1, dir),
      shift_string(three, 2, dir),
      shift_string(four, 3, dir)
    ]
  end

  defp shift_string(str, distance, :left) do
    padding = String.duplicate("?", distance)

    String.slice(str, distance, String.length(str)) <> padding
  end

  defp shift_string(str, distance, :right) do
    padding = String.duplicate("?", distance)

    padding <> String.slice(str, 0, String.length(str) - distance)
  end

  defp count_xmas(line) do
    line
    |> String.codepoints()
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.reduce(0, fn
      ~w(X M A S), count -> count + 1
      ~w(S A M X), count -> count + 1
      _, count -> count
    end)
  end

  defp build_grid(word_search) do
    coordinates =
      word_search
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {letter, c} ->
          {{r, c}, letter}
        end)
      end)

    targets =
      Enum.filter(coordinates, fn
        {_, "A"} -> true
        _ -> false
      end)

    {targets, Map.new(coordinates)}
  end

  defp x_mas?({{row, col}, _}, grid) do
    out_of_bounds = "OOB"

    {row, col}
    |> x_pattern()
    |> Enum.map(fn coordinate ->
      Map.get(grid, coordinate, out_of_bounds)
    end)
    |> Enum.join("")
    |> then(fn value ->
      # same order as x_pattern()
      value in ["MSMS", "SSMM", "SMSM", "MMSS"]
    end)
  end

  defp x_pattern({row, col}) do
    [
      {row - 1, col - 1},
      {row - 1, col + 1},
      {row + 1, col - 1},
      {row + 1, col + 1}
    ]
  end

  def part1 do
    Inputs.lines(4, :binary)
    |> search()
  end

  def part2 do
    Inputs.lines(4, :binary)
    |> x_mas_search()
  end
end
