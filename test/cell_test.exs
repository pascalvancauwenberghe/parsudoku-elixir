defmodule CellTest do
    use ExUnit.Case
    doctest Sudoku.Cell

    test "a cell starts with all possibilities" do
      cell = Sudoku.Cell.new_cell
      assert Sudoku.Cell.number_of_possible_values(cell) == Sudoku.Cell.size_of_domain
    end
    
    test "a cell with all possibilities has an unknown value" do
      cell = Sudoku.Cell.new_cell
      assert Sudoku.Cell.has_known_value?(cell) == false
    end
end