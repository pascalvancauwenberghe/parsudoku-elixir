defmodule ParSudokuTest do
  use ExUnit.Case
  doctest ParSudoku

  test "Parsudoku creates 3x3 Region structure" do
    regions = ParSudoku.new([ { "A" , {1,2,3}} ])

    assert length(regions) == 9
    region_a = Enum.at(regions,0)

    assert Sudoku.Region.known_values(region_a) == [ {1,2,3} ]
  end

  test "Helper function can more easily create region init" do
    initial = region_initial("C","1_9_2___3")

    assert initial == [ { "C" , {1,1,1}}, { "C" , {1,3,9}}, { "C" , {2,2,2}}, { "C" , {3,3,3}} ]
  end

  test "Helper function to create a set of regions" do
    initial = regions_initial(["1_2___5_9", "5462___71", "_3___6_4_" ])
    assert initial == [ { "A" ,{1, 1, 1}}, {"A", {1, 3, 2}}, {"A", {3, 1, 5}}, {"A", {3, 3, 9}} , 
                        { "B", {1, 1, 5}}, {"B", {1, 2, 4}}, {"B", {1, 3, 6}}, {"B", {2, 1, 2}}, {"B", {3, 2, 7}}, {"B", {3, 3, 1}}, 
                        { "C", {1, 2, 3}}, {"C", {2, 3, 6}}, {"C", {3, 2, 4}}]
  end

  defp regions_initial(values) do
    parse_regions(values,?A)
  end

  defp parse_regions([hd|tl],char) do
    region_initial(<< char >>,hd) ++ parse_regions(tl,char+1)
  end

  defp parse_regions([],_char) do
    []
  end

  defp region_initial(name,values) do
    for row <- 1..3 , column <- 1..3 do
      value = String.at(values,slot(row,column))
      if value != "_", do: { name , {row, column, String.to_integer(value) } }
    end
    |> Enum.filter(&(&1 != nil))
  end

  defp slot(row,column) do
    (row - 1) * 3 + (column - 1)
  end

end
