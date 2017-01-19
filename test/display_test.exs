defmodule DisplayTest do
  use ExUnit.Case
  
  doctest Sudoku.Display

  test "A Display has a name" do
    display = Sudoku.Display.new

    assert ! Sudoku.Display.solved?(display)
  end

  test "A display receives and stores known values" do
    display = Sudoku.Display.new

    Sudoku.Display.found(display,:display, "B",{1,2,3})
    Sudoku.Display.found(display,:display, "C",{2,3,6})
    Sudoku.Display.found(display,:display, "D",{3,1,5})

    assert Sudoku.Display.received(display) == [{"B",{1,2,3}}, {"C",{2,3,6}} , {"D",{3,1,5}}]
  end
end
