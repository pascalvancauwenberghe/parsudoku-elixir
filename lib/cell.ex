defmodule Sudoku.Cell do
    @moduledoc """
      A cell represents the values from the domain that are possible.
      A cell starts out with all domain values still possible
      The constraint satisfaction algorithm will reduce possibilities until only one value is possible.
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
end
