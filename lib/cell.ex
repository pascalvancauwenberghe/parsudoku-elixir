defmodule Sudoku.Cell do
    @moduledoc """
      A cell represents the values from the domain that are possible
    """

    @domain_size 9

    def new_cell do
        Enum.into(1..@domain_size,[])
    end

    def number_of_possible_values(cell) do
        length(cell)
    end

    def size_of_domain do
        @domain_size
    end

    def has_known_value?(cell) do
        number_of_possible_values(cell) == 1
    end
end
