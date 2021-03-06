defmodule Sudoku.Grid do
  @moduledoc """
    A grid is a 3x3 `Sudoku.Cell` section of the whole Sudoku puzzle

      iex> grid = Sudoku.Grid.new
      iex> Sudoku.Grid.solved?(grid)
      false
      iex> grid = Sudoku.Grid.has_known_value(grid,1,3,5)
      iex> Sudoku.Grid.cell(grid,1,3) |> Sudoku.Cell.value_of
      5
      iex> Sudoku.Grid.known_values(grid)
      [{1,3,5}]

      iex> Sudoku.Grid.rows()
      1..3
      iex> Sudoku.Grid.columns()
      1..3
 
  """
  
  alias Sudoku.Cell, as: Cell

  @type grid :: [Sudoku.Cell.t]
  @type t :: grid

  @type result :: { Sudoku.Cell.row,Sudoku.Cell.column,Sudoku.Domain.value }
  @type resultlist :: [ result ]

  @rows  3
  @columns 3

  @spec new :: grid
  @doc "Constructor: create a 3x3 Cell section of a Sudoku puzzle"
  def new do
    for the_row <- rows() , the_column <- columns() do
      Cell.new(the_row,the_column)
    end
  end

  @spec solved?(grid) :: boolean
  @doc "A Grid is solved when all of its Cells have a known value"
  def solved?(grid) do
    Enum.all?(grid,&(Cell.has_known_value?(&1)))
  end

  @spec has_known_value(grid,Sudoku.Cell.row,Sudoku.Cell.column,Sudoku.Domain.value) :: grid
  @doc "Return a grid with a Cell with the given value at the [row,column] coordinates"
  def has_known_value(grid,row,column,value) do
    position = slot(row,column)
    cell = Enum.at(grid,position) |> Cell.set_value(value)
    List.replace_at(grid,position,cell) |> apply_rules()
  end

  @spec cell(grid,Sudoku.Cell.row,Sudoku.Cell.column) :: Sudoku.Cell.t
  @doc "Return the Cell at the [row,column] coordinates"
  def cell(grid,row,column) do
    Enum.at(grid,slot(row,column))
  end

  @spec cant_have_value(grid,Sudoku.Cell.row,Sudoku.Cell.column,Sudoku.Domain.value) :: grid
  @doc "Return a grid with a Cell at [row,column] that can't have the given value"
  def cant_have_value(grid,row,column,value) do
    position = slot(row,column)
    cell = Enum.at(grid,position) |> Cell.cant_have_value(value)
    List.replace_at(grid,position,cell) |> apply_rules()
  end

  @spec cant_have_value_in_row(grid,Sudoku.Cell.row,Sudoku.Domain.value) :: grid
  @doc "Return a grid where the given value is not possible in the given row"
  def cant_have_value_in_row(grid,row,value) do
    Enum.map(grid,fn(cell) -> if Cell.row(cell) == row, do: Cell.cant_have_value(cell,value), else: cell end)
    |> apply_rules()
  end
  
  @spec cant_have_value_in_column(grid,Sudoku.Cell.column,Sudoku.Domain.value) :: grid
  @doc "Return a grid where the given value is not possible in the given column"
  def cant_have_value_in_column(grid,column,value) do
    Enum.map(grid,fn(cell) -> if Cell.column(cell) == column, do: Cell.cant_have_value(cell,value), else: cell end)
    |> apply_rules()
  end
  
  @spec known_values(grid) :: resultlist
  @doc "Return a list of {row,column,value} for each cell with a known value"
  def known_values(grid) do
    Enum.filter(grid,&(Cell.has_known_value?(&1)))
    |> Enum.map(&({Cell.row(&1),Cell.column(&1),Cell.value_of(&1) } ))
  end

  @spec rows :: Range.t
  @doc "Return all row indices"
  def rows do
    1..@rows
  end

  @spec columns :: Range.t
  @doc "Return all column indices"
  def columns do
    1..@columns
  end

  defp slot(row,column) do
    (row-1) * @columns + (column-1)
  end

  defp apply_rules(grid) do
    grid 
    |> apply_unique_value_constraint()
    |> apply_unique_possibility_constraint()
  end

  # If a cell has a known value, no other cell can have that value
  defp apply_unique_value_constraint(grid) do
    remove_possibilities(grid,found_values(grid))
  end

  defp remove_possibilities(grid,[]) do
    grid
  end

  defp remove_possibilities(grid,values) do
    Enum.map(grid,&(if Cell.has_known_value?(&1), do: &1, else: Cell.cant_have_values(&1,values)))
    |> remove_possibilities(values -- found_values(grid))
  end

  defp found_values(grid) do
    Enum.filter(grid,&(Cell.has_known_value?(&1)))
    |> Enum.map(&(Cell.value_of(&1)))
  end

  # If a cell has a possibility that is not possible in any other cell, then that must be its value
  defp apply_unique_possibility_constraint(grid) do
    grid
    |> Enum.map(&(if Cell.has_known_value?(&1), do: &1, else: find_unique_possibility_in(grid,&1)))
  end

  defp find_unique_possibility_in(grid,cell) do
    row = Cell.row(cell)
    column = Cell.column(cell)
    unique = Enum.find(Cell.values(cell),&(!find_value(grid,row,column,&1)))
    if unique == nil, do: cell, else: Cell.with_known_value(row,column,unique)
  end

  defp find_value(grid,row,column,value) do
    grid 
    |> Enum.filter(fn(cell) -> Cell.row(cell) != row || Cell.column(cell) != column end)
    |> Enum.any?(fn(cell) -> Cell.can_have_value?(cell,value) end)
  end
end
