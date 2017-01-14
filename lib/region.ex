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

  use GenServer

# Public API

  @doc "Construct a new Region with the given name and optional list of known values as {row,column,value}"
  def new(name,initial \\ []) do
    grid = Enum.reduce(initial,Sudoku.Grid.new,fn({row,column,value},grid) -> Sudoku.Grid.has_known_value(grid,row,column,value) end)
   
    {:ok,pid} = GenServer.start_link( Sudoku.Region, { name, grid })
    pid
  end

  @doc "Returns the name of the region"
  def name(region) do 
    GenServer.call(region,:name)
  end

  @doc "Returns whether included Grid is solved"
  def solved?(region) do
    GenServer.call(region,:solved?)
  end

 @doc "Returns {row,column,value} of all Cells with known value"
 def known_values(region) do
   GenServer.call(region,:known_values)
 end

# GenServer callbacks

  def handle_call(:name,_from,region) do
    {:reply , name_of(region) , region }
  end

  def handle_call(:known_values,_from,region) do
    {:reply , grid_of(region) |> Sudoku.Grid.known_values , region}
  end

  def handle_call(:solved?,_from,region) do
    {:reply ,  grid_of(region) |> Sudoku.Grid.solved? , region }
  end

  defp grid_of(state) do
    { _name , grid } = state
    grid
  end

  defp name_of(state) do
     { name , _grid } = state
     name
  end
end
