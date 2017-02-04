defmodule GridTest do
  use ExUnit.Case
  doctest Sudoku.Grid

  test "A Grid is unsolved by default" do
    grid = Sudoku.Grid.new
    assert ! Sudoku.Grid.solved?(grid)
  end

  test "can set a known solution for a cell" do
    for row <- Sudoku.Grid.rows, column <- Sudoku.Grid.columns, value <- Sudoku.Domain.values do
      grid = Sudoku.Grid.new |> Sudoku.Grid.has_known_value(row,column,value)

      assert Sudoku.Cell.value_of(Sudoku.Grid.cell(grid,row,column)) == value
    end
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

    assert Sudoku.Grid.solved?(grid)

  end

  test "can reduce the set of possible values of a Cell" do
    for row <- Sudoku.Grid.rows, column <- Sudoku.Grid.columns, value <- Sudoku.Domain.values do
      grid = Sudoku.Grid.new |> Sudoku.Grid.cant_have_value(row,column,value)

      assert ! Sudoku.Cell.can_have_value?(Sudoku.Grid.cell(grid,row,column),value)
    end
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

    grid = grid |> Sudoku.Grid.cant_have_value(3,3,9)

    assert Sudoku.Grid.solved?(grid)
    assert Sudoku.Grid.cell(grid,3,2) |> Sudoku.Cell.value_of == 9
    assert Sudoku.Grid.cell(grid,3,3) |> Sudoku.Cell.value_of == 8
  
  end

  test "a new grid has no known values" do
    grid = Sudoku.Grid.new

    assert Sudoku.Grid.known_values(grid) == []
  end
  
  test "a grid knows which Cell values are known" do
    grid = Sudoku.Grid.new
    |> Sudoku.Grid.has_known_value(1,2,9)
    |> Sudoku.Grid.has_known_value(2,3,8)
    |> Sudoku.Grid.has_known_value(3,1,7)

    assert Sudoku.Grid.known_values(grid) == [{1,2,9} , {2,3,8} , {3,1,7} ]
  end

  test "can remove a value from a row" do
    for row <- Sudoku.Grid.rows, value <- Sudoku.Domain.values do
      grid = Sudoku.Grid.new |> Sudoku.Grid.cant_have_value_in_row(row,value)

      for column <- Sudoku.Grid.columns do
        assert !Sudoku.Cell.can_have_value?(Sudoku.Grid.cell(grid,row,column),value)
        assert Sudoku.Cell.number_of_possible_values(Sudoku.Grid.cell(grid,row,column)) == Sudoku.Domain.size - 1
      end
    end
  end

  test "can remove a value from a column" do
    for column <- Sudoku.Grid.columns, value <- Sudoku.Domain.values do
      grid = Sudoku.Grid.new |> Sudoku.Grid.cant_have_value_in_column(column,value)

      for row <- Sudoku.Grid.rows do
        assert !Sudoku.Cell.can_have_value?(Sudoku.Grid.cell(grid,row,column),value)
        assert Sudoku.Cell.number_of_possible_values(Sudoku.Grid.cell(grid,row,column)) == Sudoku.Domain.size - 1
      end
    end
  end

  test "Removing values from columns activates constraints" do
    grid = Sudoku.Grid.new 
    |> Sudoku.Grid.cant_have_value_in_row(1,2)
    |> Sudoku.Grid.cant_have_value_in_row(1,3)
    |> Sudoku.Grid.cant_have_value_in_column(1,9) 
    |> Sudoku.Grid.cant_have_value_in_column(1,8) 
    |> Sudoku.Grid.cant_have_value_in_column(1,7) 
    |> Sudoku.Grid.cant_have_value_in_column(1,6) 
    |> Sudoku.Grid.cant_have_value_in_column(1,5) 
    |> Sudoku.Grid.cant_have_value_in_column(1,4) 

    assert Sudoku.Grid.cell(grid,1,1) |> Sudoku.Cell.value_of == 1

    for row <- Sudoku.Grid.rows, column <- Sudoku.Grid.columns do
      assert Sudoku.Grid.cell(grid,row,column) |> Sudoku.Cell.can_have_value?(1) == (row == 1 && column == 1)
    end
  end

 test "Removing values from rows activates constraints" do
    grid = Sudoku.Grid.new 
    |> Sudoku.Grid.cant_have_value_in_column(1,2)
    |> Sudoku.Grid.cant_have_value_in_column(1,3)
    |> Sudoku.Grid.cant_have_value_in_row(1,9) 
    |> Sudoku.Grid.cant_have_value_in_row(1,8) 
    |> Sudoku.Grid.cant_have_value_in_row(1,7) 
    |> Sudoku.Grid.cant_have_value_in_row(1,6) 
    |> Sudoku.Grid.cant_have_value_in_row(1,5) 
    |> Sudoku.Grid.cant_have_value_in_row(1,4) 

    assert Sudoku.Grid.cell(grid,1,1) |> Sudoku.Cell.value_of == 1

    for row <- Sudoku.Grid.rows, column <- Sudoku.Grid.columns do
      assert Sudoku.Grid.cell(grid,row,column) |> Sudoku.Cell.can_have_value?(1) == (row == 1 && column == 1)
    end
  end

  test "When a cell is the only one with a possibility, that is its value" do
    grid = Sudoku.Grid.new 
      |> Sudoku.Grid.has_known_value(1,1,1)
      |> Sudoku.Grid.has_known_value(1,2,2)
      |> Sudoku.Grid.has_known_value(1,3,3)
      |> Sudoku.Grid.has_known_value(2,1,4)
      |> Sudoku.Grid.has_known_value(2,2,5)
      |> Sudoku.Grid.has_known_value(2,3,6)
      |> Sudoku.Grid.cant_have_value(3,1,9)
      |> Sudoku.Grid.cant_have_value(3,2,9)

    assert Sudoku.Grid.cell(grid,3,3) |> Sudoku.Cell.has_known_value?
    assert Sudoku.Grid.cell(grid,3,3) |> Sudoku.Cell.value_of == 9
  end

end
