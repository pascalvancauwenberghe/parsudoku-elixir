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

  end

  defp region_initial(name,values) do
      if value != "_", do: { name , {row, column, String.to_integer(value) } }
    end
  end

  defp slot(row,column) do
    (row - 1) * 3 + (column - 1)
  end

end
