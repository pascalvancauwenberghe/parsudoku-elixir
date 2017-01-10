defmodule Sudoku.Region do
  @moduledoc """
    A region contains a Grid and communicates results with neighbouring Regions 

      iex> region = Sudoku.Region.new("B")
      iex> Sudoku.Region.name(region)
      "B"
      iex> Sudoku.Region.solved?(region)
      false

      iex> region = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 
      iex> Sudoku.Region.known_values(region)
      [{1,2,3}, {2,3,6} , {3,1,5}]
  """

  @doc "Construct a new Region with the given name"
  def new(name,initial \\ []) do
    grid = Enum.reduce(initial,Sudoku.Grid.new,fn({row,column,value},grid) -> Sudoku.Grid.has_known_value(grid,row,column,value) end)
    { name, grid }
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

 @doc "Returns {row,column,value} of all Cells with known value"
 def known_values(region) do
   grid(region) |> Sudoku.Grid.known_values
 end

  defp grid(region) do
    { _name , grid } = region
    grid
  end
end
