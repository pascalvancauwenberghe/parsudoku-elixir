defmodule Sudoku.Region do
  @moduledoc """
    A region contains a `Sudoku.Grid` and communicates results with neighbouring Regions 

      iex> region = Sudoku.Region.new("B")
      iex> Sudoku.Region.name(region)
      "B"
      iex> Sudoku.Region.solved?(region)
      false

      iex> region = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 
      iex> Sudoku.Region.known_values(region)
      [{1,2,3}, {2,3,6} , {3,1,5}]

      iex> left = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 
      iex> right = Sudoku.Region.new("B",[{2,3,4}, {3,1,7} , {1,2,6}]) 
      iex> Sudoku.Region.notify(right,[{:east,left}])
      iex> Sudoku.Region.received(left) ==  [{:found,:east,"B",{1,2,6}}, {:found,:east,"B",{2,3,4}}, {:found,:east,"B",{3,1,7}} ]
      true
  """

  use GenServer

# Public API

  @doc "Construct a new Region with the given name and optional list of known values as {row,column,value}"
  def new(name,initial \\ []) do
    grid = Enum.reduce(initial,Sudoku.Grid.new,fn({row,column,value},grid) -> Sudoku.Grid.has_known_value(grid,row,column,value) end)
   
    {:ok,pid} = GenServer.start_link( Sudoku.Region, { name, grid , [], []})
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

 @doc "Returns list of all received notifications in format {:found, role, from_region_name , {row, column, value}} in order received"
 def received(region) do
   GenServer.call(region,:received)
 end

 @doc "Defines which servers should be notified using call found(region,role,name,{row,column,value})"
 def notify(region,neighbours) do
   GenServer.call(region,{:notify , neighbours})
 end

 @doc "Notification from neighbour with given role and name that a value {row, column, value} was found"
 def found(region,role,name,value) do 
   GenServer.cast(region,{:found, role, name, value})
 end

# GenServer callbacks

  def handle_call(:name,_from,region) do
    {:reply , name_of(region) , region }
  end

  def handle_call(:known_values,_from,region) do
    {:reply , grid_of(region) |> Sudoku.Grid.known_values , region}
  end

  def handle_call(:received,_from,region) do
     {:reply , received_of(region) , region }
  end

  def handle_call(:solved?,_from,region) do
    {:reply ,  grid_of(region) |> Sudoku.Grid.solved? , region }
  end

  def handle_call({:notify,neighbours},_from,region) do
    known_values = Sudoku.Grid.known_values(grid_of(region))
    name = name_of(region)
    Enum.each(known_values,fn(value) -> notify_all(name,value,neighbours) end)
    {:reply ,  [] , with_neighbours(region,neighbours) }
  end

  def handle_cast({:found, role, name, value},state) do
    {:noreply , with_received(state, {:found, role, name, value}) }
  end

  defp notify_all(name,value,neighbours) do
    Enum.each(neighbours,fn({role , pid}) -> Sudoku.Region.found(pid,role,name,value) end)
  end

  defp grid_of(state) do
    { _name , grid, _neighbours, _received } = state
    grid
  end

  defp received_of(state) do
    { _name , _grid, _neighbours , received } = state
    Enum.reverse(received)
  end

  defp name_of(state) do
     { name , _grid, _neighbours, _received } = state
     name
  end

  defp with_neighbours(state,neighbours) do
    { name , grid, _neighbours , received} = state
    { name , grid, neighbours, received }
  end

  defp with_received(state,message) do 
    { name , grid, neighbours , received} = state
    { name , grid, neighbours, [message|received] }
  end

end
