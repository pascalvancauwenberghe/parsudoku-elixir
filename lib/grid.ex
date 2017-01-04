defmodule Sudoku.Grid do
  @moduledoc """
    A grid is a 3x3 Cell section of the whole Sudoku puzzle

      iex> grid = Sudoku.Grid.new
      iex> Sudoku.Grid.solved?(grid)
      false
      iex> grid = Sudoku.Grid.has_known_value(grid,1,3,5)
      iex> Sudoku.Grid.cell(grid,1,3) |> Sudoku.Cell.value_of
      5
      iex> Sudoku.Grid.known_values(grid)
      [{1,3,5}]

      iex> Sudoku.Grid.rows
      1..3
      iex> Sudoku.Grid.columns
      1..3
 
  """

  @rows  3
  @columns 3

  @doc "Constructor: create a 3x3 Cell section of a Sudoku puzzle"
  def new do
    for the_row <- rows , the_column <- columns do
     { the_row, the_column , Sudoku.Cell.new(the_row,the_column) }
    end
  end

  @doc "A Grid is solved when all of its Cells have a known value"
  def solved?(grid) do
    Enum.all?(grid,fn({_row,_column,cell}) -> Sudoku.Cell.has_known_value?(cell) end)
  end

  @doc "Return a grid with a Cell with the given value at the [row,column] coordinates"
  def has_known_value(grid,row,column,value) do
    Enum.map(grid, fn({the_row,the_column,cell}) ->
     if the_row == row && the_column == column do
        {the_row, the_column , Sudoku.Cell.with_known_value(the_row,the_column,value) }
      else
        {the_row, the_column , Sudoku.Cell.cant_have_value(cell,value) }
      end
    end)
  end

  @doc "Return the Cell at the [row,column] coordinates"
  def cell(grid,row,column) do
    {_row, _column, cell} = Enum.at(grid,slot(row,column))
    cell
  end

  @doc "Return a grid with a Cell at [row,column] that can't have the given value"
  def cant_have_value(grid,row,column,value) do
    {row,column,cell} = Enum.at(grid,slot(row,column))
    cell = Sudoku.Cell.cant_have_value(cell,value)
    if Sudoku.Cell.has_known_value?(cell) do
      has_known_value(grid,row,column, Sudoku.Cell.value_of(cell))
    else
      List.replace_at(grid,slot(row,column),{row,column,cell})
    end
  end
  
  @doc "Return a list of {row,column,value} for each cell with a known value"
  def known_values(grid) do
    Enum.filter(grid,fn({_,_,cell}) -> Sudoku.Cell.has_known_value?(cell) end)
    |> Enum.map(fn({row,column,cell}) -> {row,column,Sudoku.Cell.value_of(cell) } end)
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
