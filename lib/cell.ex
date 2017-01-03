defmodule Sudoku.Cell do
  @moduledoc """
    A cell represents the values from the domain that are possible.
    A cell starts out with all domain values still possible

    The constraint satisfaction algorithm will reduce possibilities until only one value is possible.

      ## Examples
      ## Start out with default: all values from the domain are possible
      iex> cell = Sudoku.Cell.new
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
      iex> cell == Sudoku.Cell.domain
      true
      iex> Sudoku.Cell.number_of_possible_values(cell)
      9
      iex> Sudoku.Cell.has_known_value?(cell)
      false
      iex> Enum.map(1..Sudoku.Cell.size_of_domain,fn(value) -> Sudoku.Cell.can_have_value?(cell,value) end)
      [true, true, true, true, true, true, true, true, true]
      iex> Sudoku.Cell.cant_have_value(cell,4)
      [1, 2, 3, 5, 6, 7, 8, 9]

      ## Start out with a known value
      iex> cell = Sudoku.Cell.with_known_value(6)
      [6]
      iex> Sudoku.Cell.number_of_possible_values(cell)
      1
      iex> Sudoku.Cell.has_known_value?(cell)
      true
      iex> Sudoku.Cell.value_of(cell)
      6
  """

    @domain [1,2,3,4,5,6,7,8,9]
    
    @doc "The number of different values in the domain"
    def size_of_domain do
        length(@domain)
    end

    @doc "The possible values of the domain"
    def domain do
      @domain
    end

    @doc "Constructor: Create a new cell that can have all possible values in the domain"
    def new do
        @domain
    end

    @doc "Constructor: Create a new cell with a given known value"
    def with_known_value(value) do
        [ value ]
    end

    @doc "How many values are possible in this cell?"
    def number_of_possible_values(cell) do
        length(cell)
    end

    @doc "A cell has a known value if only one possibility is left"
    def has_known_value?(cell) do
        number_of_possible_values(cell) == 1
    end

    @doc "Return the value of the cell. Only valid if the value of the cell is known."
    def value_of(cell) do
        List.first(cell)
    end

    @doc "Returns whether the given value is still possible in the cell"
    def can_have_value?(cell,value) do
        Enum.any?(cell,fn(x) -> x == value end)
    end

    @doc "Remove the given value from the possible values in the cell"
    def cant_have_value(cell,value) do
        List.delete(cell,value)
    end
end
