defmodule AdventOfCode2024.Graphs do
  # TODO: implicit direction of movement to up, down, left, right
  def connected(map, start, neighbour_fun) do
    nodes = MapSet.new([start])

    do_connected(map, neighbour_fun, nodes)
  end

  # TODO: implicit direction of movement to up, down, left, right
  def dfs(map, start, done_fun, neighbour_fun) do
    frontier = [{start, []}]

    dfs(frontier, map, done_fun, neighbour_fun, [])
  end

  defp do_connected(map, neighbour_fun, visited) do
    newly_visited =
      visited
      |> Enum.flat_map(&neighbours(&1, map))
      |> Enum.reject(&MapSet.member?(visited, &1))
      |> Enum.filter(neighbour_fun)
      |> MapSet.new()

    if MapSet.size(newly_visited) == 0 do
      visited
    else
      do_connected(map, neighbour_fun, MapSet.union(visited, newly_visited))
    end
  end

  defp dfs(frontier, map, done_fun, neighbour_fun, complete_paths)

  defp dfs([], _map, _done_fun, _neighbour_fun, complete), do: complete

  defp dfs([{coordinate, history} | rest], map, done_fun, neighbour_fun, complete) do
    value = Map.fetch!(map, coordinate)

    new_neighbours =
      coordinate
      |> neighbours(map)
      |> Enum.reject(&(&1 in history))
      |> Enum.filter(&neighbour_fun.(&1, coordinate, map))

    if done_fun.(value, coordinate, history, new_neighbours) do
      complete_path = Enum.reverse([coordinate | history])

      dfs(rest, map, done_fun, neighbour_fun, [complete_path | complete])
    else
      new_paths =
        new_neighbours
        |> Enum.map(fn next ->
          {next, [coordinate | history]}
        end)

      dfs(new_paths ++ rest, map, done_fun, neighbour_fun, complete)
    end
  end

  defp neighbours({x, y}, map) do
    [
      {x, y + 1},
      {x, y - 1},
      {x - 1, y},
      {x + 1, y}
    ]
    |> Enum.filter(&Map.has_key?(map, &1))
  end
end
