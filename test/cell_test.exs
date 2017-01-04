defmodule CellTest do
  use ExUnit.Case
  doctest Sudoku.Cell

  test "a cell starts with all possibilities" do
    cell = Sudoku.Cell.new
    assert Sudoku.Cell.number_of_possible_values(cell) == Sudoku.Domain.size
  end

  test "a cell with all possibilities has an unknown value" do
    cell = Sudoku.Cell.new
    assert ! Sudoku.Cell.has_known_value?(cell)
  end

  test "a cell's value can be set to a known value" do
    cell = Sudoku.Cell.with_known_value(5)
    assert Sudoku.Cell.has_known_value?(cell)
  end

  test "a cell can return its value when it is known" do
    cell = Sudoku.Cell.with_known_value(3)
    assert Sudoku.Cell.value_of(cell) == 3
  end

  test "all values are possible for a new cell" do
    cell =  Sudoku.Cell.new

    Enum.each(Sudoku.Domain.values,fn(value) -> assert Sudoku.Cell.can_have_value?(cell,value) end)
  end

  test "only the known value is possible for a cell with known value" do
    known = 4
    cell =  Sudoku.Cell.with_known_value(known)

    Enum.each(Sudoku.Domain.values,fn(value) -> assert Sudoku.Cell.can_have_value?(cell,value) == (value == known) end)
  end

  test "can remove a possibility from a cell" do
    cell = Sudoku.Cell.new
    cell = Sudoku.Cell.cant_have_value(cell,3)
    assert Sudoku.Cell.number_of_possible_values(cell) == 8
    assert ! Sudoku.Cell.can_have_value?(cell,3)
    assert Sudoku.Cell.can_have_value?(cell,4)
  end
end
