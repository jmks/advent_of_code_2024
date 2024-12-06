defmodule AdventOfCode2024.Day02Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day02

  describe "safe?/1" do
    test "all increasing or decreasing" do
      assert safe_report?([1, 2, 3, 4, 5])
      assert safe_report?([1, 4, 7])
      assert safe_report?([5, 4, 3, 2, 1])
      refute safe_report?([1, 1, 1])
      refute safe_report?([5, 1])
      refute safe_report?([1, 5])
    end

    test "examples" do
      assert safe_report?([7, 6, 4, 2, 1])
      refute safe_report?([1, 2, 7, 8, 9])
      refute safe_report?([9, 7, 6, 2, 1])
      refute safe_report?([1, 3, 2, 4, 5])
      refute safe_report?([8, 6, 4, 4, 1])
      assert safe_report?([1, 3, 6, 7, 9])
    end
  end
end
