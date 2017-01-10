defmodule Sudoku.Region do
  @moduledoc """
    A region contains a Grid and communicates results with neighbouring Regions 

      iex> region = Sudoku.Region.new("B")
      iex> Sudoku.Region.name(region)
      "B"
      iex> Sudoku.Region.solved?(region)
      false
  """

  @doc "Construct a new Region with the given name"
  def new(name) do
    { name, Sudoku.Grid.new }
  end

  @doc "Returns the name of the region"
  def name(region) do 
    { name , _grid } = region
    name
  end

  @doc "Returns whether included Grid is solved"
  def solved?(region) do
    grid(region) |> Sudoku.Grid.solved?
  end

  defp grid(region) do
    { _name , grid } = region
    grid
  end
end
