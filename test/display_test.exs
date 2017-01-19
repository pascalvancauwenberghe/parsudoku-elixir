defmodule DisplayTest do
  use ExUnit.Case
  
  doctest Sudoku.Display

  test "A Display has a name" do
    display = Sudoku.Display.new

    assert ! Sudoku.Display.solved?(display)
  end

  test "A display receives known values of Region" do
    display = Sudoku.Display.new

    region = Sudoku.Region.new("B",[{1,2,3}, {2,3,6} , {3,1,5}]) 

    Sudoku.Region.notify(region,[{:display, display}])

    assert Sudoku.Display.received(display) == [{"B",{1,2,3}}, {"B",{2,3,6}} , {"B",{3,1,5}}]
  end
end
