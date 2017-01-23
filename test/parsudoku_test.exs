defmodule ParSudokuTest do
  use ExUnit.Case
  doctest ParSudoku

  test "Parsudoku creates 3x3 Region structure" do
    regions = ParSudoku.new([ { "A" , {1,2,3}} ])

    assert length(regions) == 9
    region_a = Enum.at(regions,0)

    assert Sudoku.Region.known_values(region_a) == [ {1,2,3} ]
  end

end
