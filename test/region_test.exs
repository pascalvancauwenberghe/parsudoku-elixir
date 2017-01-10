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

   test "A region can be initialized with known valuess" do
    region = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 

    assert Sudoku.Region.known_values(region) == [{1,2,3}, {2,3,6} , {3,1,5}]
  end


end
