defmodule Sudoku.Grid do
  @moduledoc """
    A grid is a 3x3 Cell section of the whole Sudoku puzzle

      iex> grid = Sudoku.Grid.new
      iex> Sudoku.Grid.solved?(grid)
      false
      iex> grid = Sudoku.Grid.has_known_value(grid,1,3,5)
      iex> Sudoku.Grid.cell(grid,1,3) |> Sudoku.Cell.value_of
      5

      iex> Sudoku.Grid.rows
      1..3
      iex> Sudoku.Grid.columns
      1..3
 
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
    for the_row <- rows , the_column <- columns do
      if the_row == row && the_column == column do
        Sudoku.Cell.with_known_value(value)
      else
        Sudoku.Grid.cell(grid,the_row,the_column) |> Sudoku.Cell.cant_have_value(value)
      end
    end
  end

  @doc "Return the Cell at the [row,column] coordinates"
  def cell(grid,row,column) do
    Enum.at(grid,slot(row,column))
  end

  @doc "Return a grid with a Cell at [row,column] that can't have the given value"
  def cant_have_value(grid,row,column,value) do
    cell = cell(grid,row,column) |> Sudoku.Cell.cant_have_value(value)
    if Sudoku.Cell.has_known_value?(cell) do
      has_known_value(grid,row,column, Sudoku.Cell.value_of(cell))
    else
      List.replace_at(grid,slot(row,column),cell)
    end
  end

  @doc "Return all row indices"
  def rows do
    1..@rows
  end

  @doc "Return all column indices"
  def columns do
    1..@columns
  end

  defp slot(row,column) do
    (row-1) * @columns + (column-1)
  end
end
