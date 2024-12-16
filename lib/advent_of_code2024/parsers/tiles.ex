defmodule AdventOfCode2024.Parsers.Tiles do
  def parse(map, tile_fun) do
    map
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {tile, column} ->
        {{row, column}, tile_fun.(tile)}
      end)
    end)
  end
end
