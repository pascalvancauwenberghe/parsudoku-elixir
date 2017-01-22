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

  @type region :: pid
  @type region_name :: String.t
  @type t :: region

  use GenServer

# Public API

  @spec new(region_name,Sudoku.Grid.resultlist) :: region
  @doc "Construct a new Region with the given name and optional list of known values as {row,column,value}"
  def new(name,initial \\ []) do
    grid = Enum.reduce(initial,Sudoku.Grid.new,fn({row,column,value},grid) -> Sudoku.Grid.has_known_value(grid,row,column,value) end)
   
    {:ok,pid} = GenServer.start_link( Sudoku.Region, { name, grid , [], []})
    pid
  end

  @spec name(region) :: region_name
  @doc "Returns the name of the region"
  def name(region) do 
    GenServer.call(region,:name)
  end

  @spec solved?(region) :: boolean
  @doc "Returns whether included Grid is solved"
  def solved?(region) do
    GenServer.call(region,:solved?)
  end

 @spec known_values(region) :: Sudoku.Grid.resultlist
 @doc "Returns {row,column,value} of all Cells with known value"
 def known_values(region) do
   GenServer.call(region,:known_values)
 end

 @spec received(region) :: [ {:found , role :: atom , from_region :: region_name , Sudoku.Grid.result } ]
 @doc "Returns list of all received notifications in format {:found, role, from_region_name , {row, column, value}} in order received"
 def received(region) do
   GenServer.call(region,:received)
 end

 @spec notify(region,[ {role :: atom , pid } ]) :: []
 @doc "Defines which servers should be notified using call found(region,role,name,{row,column,value})"
 def notify(region,neighbours) do
   GenServer.call(region,{:notify , neighbours})
 end

 @spec found(region,role :: atom, from_region :: region_name, Sudoku.Grid.result) :: :ok
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
    notify_all_values(known_values,name,neighbours)
    {:reply ,  [] , with_neighbours(region,neighbours) }
  end

  def handle_cast({:found, role, name, value},state) do
    grid = grid_of(state)
    known_values = Sudoku.Grid.known_values(grid)
    grid = apply_constraint(grid,role,value)
    new_known_values = diff(Sudoku.Grid.known_values(grid),known_values)

    notify_all_values(new_known_values,name_of(state),neighbours_of(state))
    {:noreply , with_received(state, grid,{:found, role, name, value}) }
  end

  defp notify_all_values(values,name,neighbours) do
    Enum.each(values,fn(value) -> notify_all(name,value,neighbours) end)
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

  defp neighbours_of(state) do
     { _name , _grid, neighbours, _received } = state
     neighbours
  end

  defp with_neighbours(state,neighbours) do
    { name , grid, _neighbours , received} = state
    { name , grid, neighbours, received }
  end

  defp with_received(state,grid,message) do 
    { name , _grid, neighbours , received} = state
    { name , grid, neighbours, [message|received] }
  end

  defp apply_constraint(grid,role,value) do
    {row,column,cell_value} = value
    grid = cond do
      role == :north || role == :south -> Sudoku.Grid.cant_have_value_in_column(grid,column,cell_value)
      role == :east  || role == :west  -> Sudoku.Grid.cant_have_value_in_row(grid,row,cell_value)
    end
    
    grid
  end

  defp diff(list1,list2) do
    Enum.reject(list1,&(Enum.member?(list2,&1)))
  end
end
