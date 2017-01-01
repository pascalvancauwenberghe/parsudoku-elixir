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

  test "a cell's value can be set to a known value" do
    cell = Sudoku.Cell.with_known_value(5)
    assert Sudoku.Cell.has_known_value?(cell) == true
  end

  test "a cell can return its value when it is known" do
    cell = Sudoku.Cell.with_known_value(3)
    assert Sudoku.Cell.value_of(cell) == 3
  end

  test "all values are possible for a new cell" do
    cell =  Sudoku.Cell.new_cell

    Enum.each(1..Sudoku.Cell.size_of_domain,fn(value) -> assert Sudoku.Cell.can_have_value?(cell,value) end)
  end

  test "only the known value is possible for a cell with known value" do
    known = 4
    cell =  Sudoku.Cell.with_known_value(known)

    Enum.each(1..Sudoku.Cell.size_of_domain,fn(value) -> assert Sudoku.Cell.can_have_value?(cell,value) == (value == known) end)
  end
end
