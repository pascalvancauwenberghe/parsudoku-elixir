defmodule Sudoku.Grid do
  @moduledoc """
    A grid is a 3x3 Cell section of the whole Sudoku puzzle

      iex> grid = Sudoku.Grid.new
      iex> Sudoku.Grid.solved?(grid)
      false
      iex> grid = Sudoku.Grid.has_known_value(grid,1,3,5)
      iex> Sudoku.Grid.cell(grid,1,3) |> Sudoku.Cell.value_of
      5
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

  @doc "Return a grid with a Cell with the given value at the [row,column] coordinates"
  def has_known_value(grid,row,column,value) do
    List.replace_at(grid,slot(row,column),Sudoku.Cell.with_known_value(value))
  end

  @doc "Return the Cell at the [row,column] coordinates"
  def cell(grid,row,column) do
    Enum.at(grid,slot(row,column))
  end

  defp slot(row,column) do
    (row-1) * @columns + (column-1)
  end
end
