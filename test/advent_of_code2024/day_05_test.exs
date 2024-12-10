defmodule AdventOfCode2024.Day05Test do
  use ExUnit.Case, async: true

  import AdventOfCode2024.Day05

  @example """
           47|53
           97|13
           97|61
           97|47
           75|29
           61|13
           75|53
           29|13
           97|29
           53|29
           61|53
           97|53
           61|29
           47|13
           75|47
           97|75
           47|61
           75|61
           47|29
           75|13
           53|13

           75,47,61,53,29
           97,61,53,29,13
           75,29,13
           75,97,47,61,53
           61,13,29
           97,13,75,29,47
           """
           |> String.split("\n", trim: true)

  describe "parse/1" do
    test "example" do
      {page_ordering_rules, page_updates} = parse(@example)

      assert {53, 13} in page_ordering_rules
      assert {75, 53} in page_ordering_rules
      assert [61, 13, 29] in page_updates
      refute [] in page_updates
    end
  end

  describe "order?/1" do
    test "example" do
      {rules, [o1, o2, o3, u1, u2, u3]} = parse(@example)

      assert ordered?(o1, rules)
      assert ordered?(o2, rules)
      assert ordered?(o3, rules)
      refute ordered?(u1, rules)
      refute ordered?(u2, rules)
      refute ordered?(u3, rules)
    end
  end

  describe "middle_page/1" do
    test "example" do
      assert middle_page([75, 47, 61, 53, 29]) == 61
      assert middle_page([97, 61, 53, 29, 13]) == 53
      assert middle_page([75, 29, 13]) == 29
    end
  end
end
