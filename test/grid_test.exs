defmodule GridTest do
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

  test "can reduce the set of possible values of a Cell" do
    grid = Sudoku.Grid.new |> Sudoku.Grid.cant_have_value(1,2,3)

    assert Sudoku.Cell.can_have_value?(Sudoku.Grid.cell(grid,1,2),3) == false 
  end

  test "when a cell's value is known, no other cell in the grid may have that value" do
    for row <- Sudoku.Grid.rows, column <- Sudoku.Grid.columns, value <- Sudoku.Domain.values do
      grid = Sudoku.Grid.new |> Sudoku.Grid.has_known_value(row,column,value)

      for the_row <- Sudoku.Grid.rows, the_column <- Sudoku.Grid.columns do
        cell = Sudoku.Grid.cell(grid,the_row,the_column)
        assert Sudoku.Cell.can_have_value?(cell,value) == (the_row == row && the_column == column)
      end
    end
  end

  test "when the penultimate possible value is removed from a Cell, no other Cell may have that value" do
    grid = Sudoku.Grid.new
    |> Sudoku.Grid.has_known_value(1,1,1)
    |> Sudoku.Grid.has_known_value(1,2,2)
    |> Sudoku.Grid.has_known_value(1,3,3)
    |> Sudoku.Grid.has_known_value(2,1,4)
    |> Sudoku.Grid.has_known_value(2,2,5)
    |> Sudoku.Grid.has_known_value(2,3,6)
    |> Sudoku.Grid.has_known_value(3,1,7)
    |> Sudoku.Grid.cant_have_value(3,3,9)

    assert Sudoku.Grid.solved?(grid)
    assert Sudoku.Grid.cell(grid,3,2) |> Sudoku.Cell.value_of == 9
    assert Sudoku.Grid.cell(grid,3,3) |> Sudoku.Cell.value_of == 8
  
  end

end
