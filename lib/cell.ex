defmodule Sudoku.Cell do
  @moduledoc """
    A cell represents the values from the domain that are possible.
    A cell starts out with all domain values still possible

    The constraint satisfaction algorithm will reduce possibilities until only one value is possible.

      ## Examples
      ## Start out with default: all values from the domain are possible
      iex> cell = Sudoku.Cell.new_cell
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
      iex> Sudoku.Cell.number_of_possible_values(cell)
      9
      iex> Sudoku.Cell.has_known_value?(cell)
      false
      
      ## Start out with a known value
      iex> cell = Sudoku.Cell.with_known_value(6)
      [6]
      iex> Sudoku.Cell.number_of_possible_values(cell)
      1
      iex> Sudoku.Cell.has_known_value?(cell)
      true
  """

    @domain_size 9

    @doc "Create a new cell that can have all possible values in the domain"
    def new_cell do
        Enum.into(1..@domain_size,[])
    end

    @doc "How many values are possible in this cell?"
    def number_of_possible_values(cell) do
        length(cell)
    end

    @doc "The number of different values in the domain"
    def size_of_domain do
        @domain_size
    end

    @doc "A cell has a known value if only one possibility is left"
    def has_known_value?(cell) do
        number_of_possible_values(cell) == 1
    end

    @doc "Create a new cell with a given known value"
    def with_known_value(value) do
        [ value ]
    end
end
