defmodule Sudoku.Display do
  @moduledoc """
    A Display collects results from `Sudoku.Region`.

    It implementes the `Sudoku.Notifyable` behaviour

      iex> display = Sudoku.Display.new
      iex> Sudoku.Display.solved?(display)
      false
      iex> Sudoku.Display.found(display,:display, "B",{1,2,3})
      iex> Sudoku.Display.found(display,:display, "C",{2,3,6})
      iex> Sudoku.Display.found(display,:display, "D",{3,1,5})
      iex> Sudoku.Display.received(display) == [{"B",{1,2,3}}, {"C",{2,3,6}} , {"D",{3,1,5}}]
      true

  """
 
  @type display :: pid
  @type t :: display

  use GenServer
  @behaviour Sudoku.Notifyable

# Public API

  @spec new :: display
  @doc "Construct a new Display"
  def new do
    {:ok,pid} = GenServer.start_link( Sudoku.Display, { [] , nil , nil} )
    pid
  end

  @spec solved?(display) :: boolean
  @doc "Returns whether Sudoku is solved"
  def solved?(display) do
    GenServer.call(display,:solved?)
  end

   @spec received(display) :: [ {:found , role :: atom , from_region :: Sudoku.Region.region_name , Sudoku.Grid.result } ]
   @doc "Returns list of all received notifications in format {from_region_name , {row, column, value}} in order received"
   def received(display) do
     GenServer.call(display,:received)
   end

   @spec found(display,role :: atom, from_region :: Sudoku.Region.region_name, Sudoku.Grid.result) :: :ok
   @doc "Notification from region with given role and name that a value {row, column, value} was found"
   def found(display,role,name,value) do 
     GenServer.cast(display,{:found, role, name, value})
   end

   @spec when_done_notify(display,pid,any) :: :ok
   @doc "When all values are known, the given message is sent to the receiver"
   def when_done_notify(display,receiver,message) do
     GenServer.call(display,{:notify,{receiver,message}})
   end

  
# GenServer callbacks

  def handle_call(:solved?,_from,{received,_receiver,_message}=state) do
    {:reply ,  length(received) == 81 , state }
  end

  def handle_call(:received,_from,{received,_receiver,_message}=state) do
     {:reply , Enum.reverse(received) , state }
  end

  def handle_call({:notify,{receiver,message}},_from,{received,_receiver,_message}) do
    { :reply, :ok , {received,receiver,message} }
  end

  def handle_cast({:found, _role, name, value},{received,receiver,message}) do
    received = [{name,value}|received]
    if length(received) == 81 && receiver != nil do 
      send receiver,message
    end
    {:noreply , { received , receiver,message}}
  end

 end
