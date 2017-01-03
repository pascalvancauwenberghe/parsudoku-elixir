defmodule Sudoku.Domain do
    @moduledoc """
      The domain represents the universe from which possible values of a constraint satisfaction variable are taken
    """

    @domain [1,2,3,4,5,6,7,8,9]

    @doc "The number of different values in the domain"
    def size do
        length(@domain)
    end

    @doc "The possible values of the domain"
    def values do
      @domain
    end
end