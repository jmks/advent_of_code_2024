defmodule AdventOfCode2024.Day07Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day07

  @example """
           190: 10 19
           3267: 81 40 27
           83: 17 5
           156: 15 6
           7290: 6 8 6 15
           161011: 16 10 13
           192: 17 8 14
           21037: 9 7 18 13
           292: 11 6 16 20
           """
           |> String.split("\n", trim: true)

  describe "parse/1" do
    test "example" do
      assert parse(@example) == [
               {190, [10, 19]},
               {3267, [81, 40, 27]},
               {83, [17, 5]},
               {156, [15, 6]},
               {7290, [6, 8, 6, 15]},
               {161_011, [16, 10, 13]},
               {192, [17, 8, 14]},
               {21037, [9, 7, 18, 13]},
               {292, [11, 6, 16, 20]}
             ]
    end
  end

  describe "possible?/1" do
    test "example" do
      assert possible?({190, [10, 19]})
      assert possible?({3267, [81, 40, 27]})
      refute possible?({83, [17, 5]})
      refute possible?({156, [15, 6]})
      refute possible?({7290, [6, 8, 6, 15]})
      refute possible?({161_011, [16, 10, 13]})
      refute possible?({192, [17, 8, 14]})
      refute possible?({21037, [9, 7, 18, 13]})
      assert possible?({292, [11, 6, 16, 20]})
    end

    test "with concat" do
      operators = [:add, :mul, :cat]

      assert possible?({156, [15, 6]}, operators)
      assert possible?({7290, [6, 8, 6, 15]}, operators)
      assert possible?({192, [17, 8, 14]}, operators)
    end
  end

  test "intersperse/2" do
    assert intersperse([1, 2, 3], [:a, :b]) == [1, :a, 2, :b, 3]
    assert intersperse([1, 2], [:a, :b]) == [1, :a, 2, :b]
  end

  test "eval_equation/1" do
    assert eval_equation([1, :add, 2]) == 3
    assert eval_equation([1, :mul, 2, :add, 3]) == 5
  end

  test "permutations" do
    assert permutations([1, 2], 0) == [[]]
    assert permutations([1, 2], 1) == [[1], [2]]
    assert permutations([1, 2], 2) == [[1, 1], [1, 2], [2, 1], [2, 2]]

    assert permutations([1, 2], 3) == [
             [1, 1, 1],
             [1, 1, 2],
             [1, 2, 1],
             [1, 2, 2],
             [2, 1, 1],
             [2, 1, 2],
             [2, 2, 1],
             [2, 2, 2]
           ]
  end
end
