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
  
  alias Sudoku.Cell, as: Cell

  @rows  3
  @columns 3

  @doc "Constructor: create a 3x3 Cell section of a Sudoku puzzle"
  def new do
    for the_row <- rows , the_column <- columns do
      Cell.new(the_row,the_column)
    end
  end

  @doc "A Grid is solved when all of its Cells have a known value"
  def solved?(grid) do
    Enum.all?(grid,&(Cell.has_known_value?(&1)))
  end

  @doc "Return a grid with a Cell with the given value at the [row,column] coordinates"
  def has_known_value(grid,row,column,value) do
    position = slot(row,column)
    cell = Enum.at(grid,position) |> Cell.set_value(value)
    List.replace_at(grid,position,cell) |> apply_unique_constraint()
  end

  @doc "Return the Cell at the [row,column] coordinates"
  def cell(grid,row,column) do
    Enum.at(grid,slot(row,column))
  end

  @doc "Return a grid with a Cell at [row,column] that can't have the given value"
  def cant_have_value(grid,row,column,value) do
    position = slot(row,column)
    cell = Enum.at(grid,position) |> Cell.cant_have_value(value)
    List.replace_at(grid,position,cell) |> apply_unique_constraint()
  end

  @doc "Return a grid where the given value is not possible in the given row"
  def cant_have_value_in_row(grid,row,value) do
    Enum.map(grid,fn(cell) -> if Cell.row(cell) == row, do: Cell.cant_have_value(cell,value), else: cell end)
  end
  
  @doc "Return a grid where the given value is not possible in the given column"
  def cant_have_value_in_column(grid,column,value) do
    Enum.map(grid,fn(cell) -> if Cell.column(cell) == column, do: Cell.cant_have_value(cell,value), else: cell end)
  end
  
  @doc "Return a list of {row,column,value} for each cell with a known value"
  def known_values(grid) do
    Enum.filter(grid,&(Cell.has_known_value?(&1)))
    |> Enum.map(&({Cell.row(&1),Cell.column(&1),Cell.value_of(&1) } ))
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

  defp apply_unique_constraint(grid) do
    remove_possibilities(grid,found_values(grid))
  end

  defp remove_possibilities(grid,[]) do
    grid
  end

  defp remove_possibilities(grid,values) do
    Enum.map(grid,&(if Cell.has_known_value?(&1), do: &1, else: Cell.cant_have_values(&1,values)))
    |> remove_possibilities(diff(values,found_values(grid)))
  end

  defp found_values(grid) do
    Enum.filter(grid,&(Cell.has_known_value?(&1)))
    |> Enum.map(&(Cell.value_of(&1)))
  end

  defp diff(list1,list2) do
    Enum.reject(list1,&(Enum.member?(list2,&1)))
  end
end
