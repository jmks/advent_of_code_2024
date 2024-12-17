defmodule AdventOfCode2024.Day09Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day09

  @example "2333133121414131402"

  describe "parse/1" do
    test "short examples" do
      assert parse("12345") == [
               {:file, 0, 1},
               {:free, 2},
               {:file, 1, 3},
               {:free, 4},
               {:file, 2, 5}
             ]
    end
  end

  describe "compact/1" do
    test "short example" do
      compacted = "12345" |> parse() |> compact(:block)

      assert compacted == [
               {:file, 0, 1},
               {:free, 0},
               {:file, 2, 2},
               {:free, 0},
               {:file, 1, 3},
               {:free, 0},
               {:file, 2, 3}
             ]
    end

    test "example by block" do
      compacted = @example |> parse() |> compact(:block)

      assert compacted == [
               {:file, 0, 2},
               {:free, 0},
               {:file, 9, 2},
               {:free, 0},
               {:file, 8, 1},
               {:free, 0},
               {:file, 1, 3},
               {:free, 0},
               {:file, 8, 3},
               {:free, 0},
               {:file, 2, 1},
               {:free, 0},
               {:file, 7, 3},
               {:free, 0},
               {:file, 3, 3},
               {:free, 0},
               {:file, 6, 1},
               {:free, 0},
               {:file, 4, 2},
               {:free, 0},
               {:file, 6, 1},
               {:free, 0},
               {:file, 5, 4},
               {:free, 0},
               {:file, 6, 2}
             ]
    end

    test "move single file" do
      assert "133" |> parse() |> compact(:file) == [
               {:file, 0, 1},
               {:free, 0},
               {:file, 1, 3},
               {:free, 3}
             ]
    end

    test "example by file" do
      compacted = @example |> parse() |> compact(:file)

      assert compacted == [
               {:file, 0, 2},
               {:free, 0},
               {:file, 9, 2},
               {:free, 0},
               {:file, 2, 1},
               {:free, 0},
               {:file, 1, 3},
               {:free, 0},
               {:file, 7, 3},
               {:free, 1},
               {:file, 4, 2},
               {:free, 1},
               {:file, 3, 3},
               {:free, 4},
               {:file, 5, 4},
               {:free, 1},
               {:file, 6, 4},
               {:free, 5},
               {:file, 8, 4},
               {:free, 2}
             ]
    end
  end

  test "checksum/1" do
    parsed = parse(@example)

    assert parsed |> compact(:block) |> checksum() == 1928
    assert parsed |> compact(:file) |> checksum() == 2858
  end
end
