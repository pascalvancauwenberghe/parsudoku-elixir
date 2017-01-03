defmodule GridGridTest do
  use ExUnit.Case
  doctest Sudoku.Grid

  test "A Grid is unsolved by default" do
    grid = Sudoku.Grid.new
    assert Sudoku.Grid.solved?(grid) == false
  end
end
