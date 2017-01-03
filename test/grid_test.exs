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

  test "when all cells have a known value, the grid is solved" do
    grid = Sudoku.Grid.new
    |> Sudoku.Grid.has_known_value(1,1,1)
    |> Sudoku.Grid.has_known_value(1,2,2)
    |> Sudoku.Grid.has_known_value(1,3,3)
    |> Sudoku.Grid.has_known_value(2,1,4)
    |> Sudoku.Grid.has_known_value(2,2,5)
    |> Sudoku.Grid.has_known_value(2,3,6)
    |> Sudoku.Grid.has_known_value(3,1,7)
    |> Sudoku.Grid.has_known_value(3,2,8)
    |> Sudoku.Grid.has_known_value(3,3,9)

    assert Sudoku.Grid.solved?(grid) == true

  end
end
