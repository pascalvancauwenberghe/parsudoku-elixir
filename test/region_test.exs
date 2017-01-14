defmodule Test.StubGenServer do
  
   use GenServer

   def init(state) do
     {:ok , state }
   end

   def received(pid) do
      GenServer.call(pid,:messages)
   end

   def handle_call(:messages,_from,state) do 
     {:reply , Enum.reverse(state) , state }
   end

   def handle_call(message,from,state) do
     {:reply , [] , [message | state] }
   end

   def handle_cast(message,state) do 
     {:noreply , [message | state] }
   end
end

defmodule RegionTest do
  use ExUnit.Case
  
  doctest Sudoku.Region

  test "A region has a name" do
    region = Sudoku.Region.new("A") 

    assert Sudoku.Region.name(region) == "A"
  end

  test "A region starts out unsolved" do
    region = Sudoku.Region.new("B")

    assert ! Sudoku.Region.solved?(region)
  end

   test "A region can be initialized with known valuess" do
    region = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 

    assert Sudoku.Region.known_values(region) == [{1,2,3}, {2,3,6} , {3,1,5}]
  end

  test "it notifies all connections of known values" do
    {:ok,pid} = GenServer.start_link( Test.StubGenServer, [])

    region = Sudoku.Region.new("A",[{1,2,3}, {2,3,6} , {3,1,5}]) 

    Sudoku.Region.notify(region,[{:display , pid }])

    assert Test.StubGenServer.received(pid) == [{:found,:display,"A",{1,2,3}}, {:found,:display,"A",{2,3,6}} , {:found,:display,"A",{3,1,5}}]
  end

end
