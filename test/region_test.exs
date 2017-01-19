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

  test "it notifies all neighbours of known values" do
    right = Sudoku.Region.new("C") 
    left = Sudoku.Region.new("A") 

    region = Sudoku.Region.new("B",[{1,2,3}, {2,3,6} , {3,1,5}]) 

    Sudoku.Region.notify(region,[{:west, left}, {:east , right }])

    assert Sudoku.Region.received(left) == [{:found,:west,"B",{1,2,3}}, {:found,:west,"B",{2,3,6}} , {:found,:west,"B",{3,1,5}}]
    assert Sudoku.Region.received(right) == [{:found,:east,"B",{1,2,3}}, {:found,:east,"B",{2,3,6}} , {:found,:east,"B",{3,1,5}}]
  end

  test "it applies constraints when notified of known values" do
    display = Sudoku.Display.new

    almost_solved = Sudoku.Region.new("B",[{1,1,1}, {1,2,2} , {1,3,3} , {2,1,4}, {2,2,5} , {2,3,6} , {3,1,7}]) 

    Sudoku.Region.notify(almost_solved,[{:display,display}])

    Sudoku.Region.found(almost_solved,:south,"E",{3,2,8})
    
    assert Sudoku.Region.solved?(almost_solved)

    assert Sudoku.Display.received(display) == [{"B",{1,1,1}}, {"B",{1,2,2}} , {"B",{1,3,3}} , {"B",{2,1,4}}, {"B",{2,2,5}} , {"B",{2,3,6}} , {"B",{3,1,7}} , {"B",{3,2,9}} , {"B",{3,3,8}} ]
    
  end

end
