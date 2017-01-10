defmodule RegionTest do
  use ExUnit.Case
  
  doctest Sudoku.Region

  test "A region has a name" do
    region = Sudoku.Region.new("A") 

    assert Sudoku.Region.name(region) == "A"
  end

  test "A region starts out unsolved" do
    region = Sudoku.Region.new("B")

    assert ! Sudoku.Region.solved?(region)
  end
end
