defmodule GridGridTest do
  use ExUnit.Case
  doctest Sudoku.Grid

  test "A Grid is unsolved by default" do
    grid = Sudoku.Grid.new
    assert Sudoku.Grid.solved?(grid) == false
  end

  test "can set a known solution for a cell" do
    grid = Sudoku.Grid.new
    |> Sudoku.Grid.has_known_value(1,2,3)

    assert Sudoku.Cell.value_of(Sudoku.Grid.cell(grid,1,2)) == 3
  end
end
