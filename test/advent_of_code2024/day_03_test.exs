defmodule AdventOfCode2024.Day03Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day03

  @example "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  describe "valid_muls/1" do
    test "example" do
      assert valid_muls(@example) == [
               "mul(2,4)",
               "mul(5,5)",
               "mul(11,8)",
               "mul(8,5)"
             ]
    end
  end

  describe "eval_mul/1" do
    test "multiples" do
      assert eval_mul("mul(2,4)") == 8
      assert eval_mul("mul(5,5)") == 25
      assert eval_mul("mul(11,8)") == 88
      assert eval_mul("mul(123,456)") == 123 * 456
    end
  end
end
