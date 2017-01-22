defmodule Sudoku.Cell do
  @moduledoc """
    A cell represents the values from the `Sudoku.Domain` that are possible.
    A cell starts out with all domain values still possible

    The constraint satisfaction algorithm will reduce possibilities until only one value is possible.

      ## Examples
      ## Start out with default: all values from the domain are possible
      iex> cell = Sudoku.Cell.new(3,2)
      iex> Sudoku.Cell.row(cell)
      3
      iex> Sudoku.Cell.column(cell)
      2
      iex> Sudoku.Cell.number_of_possible_values(cell) == Sudoku.Domain.size
      true
      iex> Sudoku.Cell.has_known_value?(cell)
      false
      iex> Enum.map(Sudoku.Domain.values,fn(value) -> Sudoku.Cell.can_have_value?(cell,value) end)
      [true, true, true, true, true, true, true, true, true]

      iex> cell = Sudoku.Cell.new(3,2)
      iex> cell = Sudoku.Cell.cant_have_value(cell,4)
      iex> Sudoku.Cell.number_of_possible_values(cell) == Sudoku.Domain.size-1
      true
      iex> Enum.map(Sudoku.Domain.values,fn(value) -> Sudoku.Cell.can_have_value?(cell,value) end)
      [true, true, true, false, true, true, true, true, true]

      ## Start out with a known value
      iex> cell = Sudoku.Cell.with_known_value(2,1,6)
      iex> Sudoku.Cell.number_of_possible_values(cell)
      1
      iex> Sudoku.Cell.has_known_value?(cell)
      true
      iex> Sudoku.Cell.value_of(cell)
      6
  """

  @typedoc """
  A cell is a { row, column, value}
  """
    @type row :: number
    @type column :: column
    @type cell :: {row, column, Sudoku.Domain.valuelist}


    @spec new(row, column) :: cell
    @doc "Constructor: Create a new cell that can have all possible values in the domain"
    def new(row,column) do
      {row, column, Sudoku.Domain.values}
    end

    @spec with_known_value(row,column,Sudoku.Domain.value) :: cell
    @doc "Constructor: Create a new cell with a given known value"
    def with_known_value(row,column,value) do
      {row, column, [ value ]}
    end

    @spec number_of_possible_values(cell) :: number
    @doc "How many values are possible in this cell?"
    def number_of_possible_values(cell) do
      values(cell) |> length
    end

    @spec has_known_value?(cell) :: boolean
    @doc "A cell has a known value if only one possibility is left"
    def has_known_value?(cell) do
      number_of_possible_values(cell) == 1
    end

    @spec value_of(cell) :: Sudoku.Domain.value
    @doc "Return the value of the cell. Only valid if the value of the cell is known."
    def value_of(cell) do
      values(cell) |> List.first
    end

    @spec can_have_value?(cell,Sudoku.Domain.value) :: boolean 
    @doc "Returns whether the given value is still possible in the cell"
    def can_have_value?(cell,value) do
      values(cell) |> Enum.any?(&(&1 == value))
    end

    @spec cant_have_value(cell,Sudoku.Domain.value) :: cell 
    @doc "Remove the given value from the possible values in the cell"
    def cant_have_value(cell,value) do
      {row,column,values} = cell
      {row,column,List.delete(values,value)}
    end

    @spec cant_have_values(cell,Sudoku.Domain.valuelist) :: cell
    @doc "Remove the given values from the possible values in the cell"
    def cant_have_values(cell,forbidden_values) do
      {row,column,values} = cell
      {row,column,Enum.reject(values,&(Enum.member?(forbidden_values,&1)))}
    end

    @spec set_value(cell,Sudoku.Domain.value) :: cell
    @doc "Set the value of the cell, keeping coordinates"
    def set_value(cell,value) do
      {row,column,_values} = cell
      {row,column,[value]}
    end

    @spec column(cell) :: column
    @doc "Return the column (X) coordinate of the Cell"
    def column(cell) do
      {_row,column,_values} = cell
      column
    end

    @spec row(cell) :: row
    @doc "Return the row (Y) coordinate of the Cell"
    def row(cell) do
      {row,_column,_values} = cell
      row
    end

    @spec values(cell) :: Sudoku.Domain.valuelist
    defp values(cell) do
      {_row,_column,values} = cell
      values
    end
end
