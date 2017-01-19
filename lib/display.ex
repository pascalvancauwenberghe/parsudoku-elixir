defmodule Sudoku.Display do
  @moduledoc """
    A Display collects results from Regions

      iex> display = Sudoku.Display.new
      iex> Sudoku.Display.solved?(display)
      false

  """

  use GenServer

# Public API

  @doc "Construct a new Display"
  def new do
    {:ok,pid} = GenServer.start_link( Sudoku.Display, [])
    pid
  end

  @doc "Returns whether included Grid is solved"
  def solved?(display) do
    GenServer.call(display,:solved?)
  end

   @doc "Returns list of all received notifications in format {from_region_name , {row, column, value}} in order received"
   def received(display) do
     GenServer.call(display,:received)
   end

   @doc "Notification from region with given role and name that a value {row, column, value} was found"
   def found(display,role,name,value) do 
     GenServer.cast(display,{:found, role, name, value})
   end

  
# GenServer callbacks

  def handle_call(:solved?,_from,state) do
    {:reply ,  length(state) == 81 , state }
  end

  def handle_call(:received,_from,state) do
     {:reply , Enum.reverse(state) , state }
  end

  def handle_cast({:found, _role, name, value},state) do
    {:noreply , [{name,value}|state] }
  end

 end
