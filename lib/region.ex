defmodule Sudoku.Region do
  @moduledoc """
    A region contains a Grid and communicates results with neighbouring Regions 

      iex> region = Sudoku.Region.new("B")
      iex> Sudoku.Region.name(region)
      "B"
  """

  @doc "Construct a new Region with the given name"
  def new(name) do
    { name }
  end

  @doc "Returns the name of the region"
  def name(region) do 
    { name } = region
    name
  end
end