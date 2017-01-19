defmodule DisplayTest do
  use ExUnit.Case
  
  doctest Sudoku.Display

  test "A Display has a name" do
    display = Sudoku.Display.new

    assert ! Sudoku.Display.solved?(display)
  end

end
