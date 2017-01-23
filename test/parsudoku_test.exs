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
