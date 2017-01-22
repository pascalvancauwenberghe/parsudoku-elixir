defmodule Sudoku.Domain do
    @moduledoc """
      The domain represents the universe from which possible values of a constraint satisfaction variable are taken
    """

    @type value :: number
    @type valuelist :: [value]
    @domain [1,2,3,4,5,6,7,8,9]

    @spec size :: number
    @doc "The number of different values in the domain"
    def size do
        length(@domain)
    end

    @spec values :: valuelist
    @doc "The possible values of the domain"
    def values do
      @domain
    end
end