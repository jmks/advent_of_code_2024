defmodule AdventOfCode2024.Parsers.Tiles do
  defmodule TileMap do
    defstruct [:tiles, :current, :x_max, :y_max]
  end

  defimpl Enumerable, for: TileMap do
    alias AdventOfCode2024.Parsers.Tiles.TileMap

    def reduce(map, acc, fun) do
      Enum.reduce(map.tiles, acc, fun)
    end

    def count(map) do
      {:ok, map_size(map.tiles)}
    end

    def member?(map, element) do
      {:ok, element in map.tiles}
    end

    def slice(_map) do
      {:error, TileMap}
    end
  end

  def as_map(input, tile_fun) do
    map = %TileMap{x_max: String.length(hd(input)), y_max: length(input), tiles: Map.new()}

    input
    |> parse(tile_fun)
    |> Enum.reduce(map, fn
      {{_, _}, :ignore}, acc ->
        acc

      {{y, x}, {:current, value}}, acc ->
        %{acc | current: {x, y}, tiles: Map.put(acc.tiles, {x, y}, value)}

      {{y, x}, {:ok, value}}, acc ->
        %{acc | tiles: Map.put(acc.tiles, {x, y}, value)}
    end)
  end

  # Note: this uses the coordinates in a {y, x} format that was specific to a problem
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
