defmodule AdventOfCode2024.Day09 do
  @moduledoc """
  --- Day 9: Disk Fragmenter ---

  Another push of the button leaves you in the familiar hallways of some friendly amphipods! Good thing you each somehow got your own personal mini submarine. The Historians jet away in search of the Chief, mostly by driving directly into walls.

  While The Historians quickly figure out how to pilot these things, you notice an amphipod in the corner struggling with his computer. He's trying to make more contiguous free space by compacting all of the files, but his program isn't working; you offer to help.

  He shows you the disk map (your puzzle input) he's already generated. For example:

  2333133121414131402

  The disk map uses a dense format to represent the layout of files and free space on the disk. The digits alternate between indicating the length of a file and the length of free space.

  So, a disk map like 12345 would represent a one-block file, two blocks of free space, a three-block file, four blocks of free space, and then a five-block file. A disk map like 90909 would represent three nine-block files in a row (with no free space between them).

  Each file on disk also has an ID number based on the order of the files as they appear before they are rearranged, starting with ID 0. So, the disk map 12345 has three files: a one-block file with ID 0, a three-block file with ID 1, and a five-block file with ID 2. Using one character for each block where digits are the file ID and . is free space, the disk map 12345 represents these individual blocks:

  0..111....22222

  The first example above, 2333133121414131402, represents these individual blocks:

  00...111...2...333.44.5555.6666.777.888899

  The amphipod would like to move file blocks one at a time from the end of the disk to the leftmost free space block (until there are no gaps remaining between file blocks). For the disk map 12345, the process looks like this:

  0..111....22222
  02.111....2222.
  022111....222..
  0221112...22...
  02211122..2....
  022111222......

  The first example requires a few more steps:

  00...111...2...333.44.5555.6666.777.888899
  009..111...2...333.44.5555.6666.777.88889.
  0099.111...2...333.44.5555.6666.777.8888..
  00998111...2...333.44.5555.6666.777.888...
  009981118..2...333.44.5555.6666.777.88....
  0099811188.2...333.44.5555.6666.777.8.....
  009981118882...333.44.5555.6666.777.......
  0099811188827..333.44.5555.6666.77........
  00998111888277.333.44.5555.6666.7.........
  009981118882777333.44.5555.6666...........
  009981118882777333644.5555.666............
  00998111888277733364465555.66.............
  0099811188827773336446555566..............

  The final step of this file-compacting process is to update the filesystem checksum. To calculate the checksum, add up the result of multiplying each of these blocks' position with the file ID number it contains. The leftmost block is in position 0. If a block contains free space, skip it instead.

  Continuing the first example, the first few blocks' position multiplied by its file ID number are 0 * 0 = 0, 1 * 0 = 0, 2 * 9 = 18, 3 * 9 = 27, 4 * 8 = 32, and so on. In this example, the checksum is the sum of these, 1928.

  Compact the amphipod's hard drive using the process he requested. What is the resulting filesystem checksum? (Be careful copy/pasting the input for this puzzle; it is a single, very long line.)

  --- Part Two ---

  Upon completion, two things immediately become clear. First, the disk definitely has a lot more contiguous free space, just like the amphipod hoped. Second, the computer is running much more slowly! Maybe introducing all of that file system fragmentation was a bad idea?

  The eager amphipod already has a new plan: rather than move individual blocks, he'd like to try compacting the files on his disk by moving whole files instead.

  This time, attempt to move whole files to the leftmost span of free space blocks that could fit the file. Attempt to move each file exactly once in order of decreasing file ID number starting with the file with the highest file ID number. If there is no span of free space to the left of a file that is large enough to fit the file, the file does not move.

  The first example from above now proceeds differently:

  00...111...2...333.44.5555.6666.777.888899
  0099.111...2...333.44.5555.6666.777.8888..
  0099.1117772...333.44.5555.6666.....8888..
  0099.111777244.333....5555.6666.....8888..
  00992111777.44.333....5555.6666.....8888..

  The process of updating the filesystem checksum is the same; now, this example's checksum would be 2858.

  Start over, now compacting the amphipod's hard drive using this new method instead. What is the resulting filesystem checksum?
  """
  def part1 do
    Inputs.binary(9)
    |> parse()
    |> compact(:block)
    |> checksum()
  end

  def part2 do
    Inputs.binary(9)
    |> parse()
    |> compact(:file)
    |> checksum()
  end

  def parse(disk_map) do
    do_parse(String.codepoints(disk_map), :file, 0, [])
  end

  defp do_parse([], _type, _file_no, disk), do: Enum.reverse(disk)

  defp do_parse([blocks | rest], :file, file_no, disk) do
    new_file = {:file, file_no, String.to_integer(blocks)}

    do_parse(rest, :free, file_no + 1, [new_file | disk])
  end

  defp do_parse([free | rest], :free, file_no, disk) do
    do_parse(rest, :file, file_no, [{:free, String.to_integer(free)} | disk])
  end

  def compact(disk, :block) do
    array = to_array(disk)

    array
    |> compact_blocks(next_free(array, 0), :array.size(array) - 1)
    |> from_array()
  end

  def compact(disk, :file) do
    files_to_move =
      disk
      |> Enum.filter(&match?({:file, _, _}, &1))
      |> Enum.reverse()

    compact_files(files_to_move, disk)
  end

  defp to_array(disk) do
    disk
    |> Enum.flat_map(fn
      {:file, id, blocks} -> List.duplicate(id, blocks)
      {:free, blocks} -> List.duplicate(:free, blocks)
    end)
    |> :array.from_list()
  end

  defp from_array(array) do
    0..(:array.size(array) - 1)
    |> Enum.map(fn i -> :array.get(i, array) end)
    |> Enum.chunk_while(
      [],
      fn
        el, [] -> {:cont, [el]}
        el, [el | _] = acc -> {:cont, [el | acc]}
        el, chunk -> {:cont, chunk, [el]}
      end,
      fn chunk -> {:cont, chunk, []} end
    )
    |> Enum.reduce([], fn
      [:free | _], acc -> acc
      [:undefined | _], acc -> acc
      [id | _] = chunk, acc -> [{:free, 0}, {:file, id, length(chunk)} | acc]
    end)
    |> then(fn
      [{:free, _} | rest] -> Enum.reverse(rest)
    end)
  end

  defp compact_files([], disk), do: disk

  defp compact_files([{:file, id, blocks} | rest], disk) do
    # Uncomment for a "trace" of changes
    # print_disk(disk)

    spot =
      Enum.find_index(disk, fn
        {:free, space} when space >= blocks -> true
        _ -> false
      end)

    index = Enum.find_index(disk, &match?({:file, ^id, _}, &1))

    if is_integer(spot) and spot < index do
      new_disk =
        disk
        |> delete_file(id)
        |> put_file(spot, {:file, id, blocks})

      compact_files(rest, new_disk)
    else
      compact_files(rest, disk)
    end
  end

  # defp print_disk(disk) do
  #   disk
  #   |> Enum.map(fn
  #     {:file, id, blocks} -> List.duplicate(to_string(id), blocks)
  #     {:free, space} -> List.duplicate(".", space)
  #   end)
  #   |> IO.puts()
  # end

  defp put_file([{:free, space} | rest], 0, {:file, id, blocks}) do
    [{:free, 0}, {:file, id, blocks}, {:free, space - blocks} | rest]
  end

  defp put_file([thing | rest], index, file) do
    [thing | put_file(rest, index - 1, file)]
  end

  defp delete_file([{:file, id, blocks}, {:free, space} | rest], id) do
    [{:free, space + blocks} | rest]
  end

  defp delete_file([{:free, space_1}, {:file, id, blocks}, {:free, space_2} | rest], id) do
    [{:free, space_1 + blocks + space_2} | rest]
  end

  defp delete_file([{:free, space}, {:file, id, blocks}], id) do
    [{:free, space + blocks}]
  end

  defp delete_file([thing | rest], id) do
    [thing | delete_file(rest, id)]
  end

  defp compact_blocks(array, free, index) when free >= index, do: array

  defp compact_blocks(array, free, index) do
    array = :array.set(free, :array.get(index, array), array)
    array = :array.set(index, :undefined, array)

    compact_blocks(array, next_free(array, free + 1), next_block(array, index - 1))
  end

  defp next_free(array, index) do
    case :array.get(index, array) do
      :free -> index
      :undefined -> :array.size(array)
      _ -> next_free(array, index + 1)
    end
  end

  defp next_block(array, index) do
    case :array.get(index, array) do
      :free -> next_block(array, index - 1)
      :undefined -> 0
      _ -> index
    end
  end

  def checksum(disk) do
    do_checksum(disk, 0, 0)
  end

  defp do_checksum([], _index, sum), do: sum

  defp do_checksum([{:free, blocks} | rest], index, sum) do
    do_checksum(rest, index + blocks - 1, sum)
  end

  defp do_checksum([{:file, id, blocks} | rest], index, sum) do
    block_sum =
      index..(index + blocks)
      |> Enum.zip(List.duplicate(id, blocks))
      |> Enum.reduce(0, fn {i, id}, acc -> i * id + acc end)

    do_checksum(rest, index + blocks + 1, sum + block_sum)
  end
end
