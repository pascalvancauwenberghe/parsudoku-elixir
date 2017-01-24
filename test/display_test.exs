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

  test "A display notifies when it's solved" do
    display = Sudoku.Display.new

    Sudoku.Display.when_done_notify(display,self(),:done)

    for region <- ?A..?I , row <- 1..3, column <- 1..3 do
     # IO.inspect { << region >>,{ row, column, value_of(row,column) } }
      Sudoku.Display.found(display,:display,<< region >>,{ row, column, value_of(row,column) })
    end
    receive do
      :done -> :ok
      after 5000 -> assert false,"Did'nt received notification that sudoku was solved"
    end
  end

  defp value_of(row,column) do
    (row - 1) * 3 + column
  end

end
