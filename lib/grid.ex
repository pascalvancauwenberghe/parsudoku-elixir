defmodule Sudoku.Grid do
  @moduledoc """
    A grid is a 3x3 Cell section of the whole Sudoku puzzle

      iex> grid = Sudoku.Grid.new
      iex> Sudoku.Grid.solved?(grid)
      false
  """

  @rows  3
  @columns 3

  @doc "Constructor: create a 3x3 Cell section of a Sudoku puzzle"
  def new do
    Enum.into(1..@rows * @columns,[],fn(_) -> Sudoku.Cell.new end)
  end

  @doc "A Grid is solved when all of its Cells have a known value"
  def solved?(grid) do
    Enum.all?(grid,fn(cell) -> Sudoku.Cell.has_known_value?(cell) end)
  end
end
