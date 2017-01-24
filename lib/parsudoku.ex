defmodule ParSudoku do
   @moduledoc """
    The ParSudoku creates the full Sudoku puzzle from 9 `Sudoku.Region`.

      iex> { _display , regions } = ParSudoku.new([ { "A" , {1,2,3}} ])
      iex> length(regions)
      9

   """

  @doc "Create a new puzzle with known initial values [{ region_name, Grid.result} ]"
  def new(initial) do
    regions = for char <- ?A .. ?I do
      name = << char >> 
      initial_values = initial |> Enum.filter_map(fn({region_name,_result}) -> region_name == name end,fn({_region_name,result}) -> result end)
      Sudoku.Region.new(name,initial_values)
    end
    display = Sudoku.Display.new
    { display , regions }
  end

  def solve({display,[a,b,c,d,e,f,g,h,i]}) do
    Sudoku.Display.when_done_notify(display,self(),:done)

    Sudoku.Region.notify(a, [ {:display, display}, {:west , c} , {:east, b} , {:north, g} , {:south, d}])
    Sudoku.Region.notify(b, [ {:display, display}, {:west , a} , {:east, c} , {:north, h} , {:south, e}])
    Sudoku.Region.notify(c, [ {:display, display}, {:west , b} , {:east, a} , {:north, i} , {:south, f}])
    Sudoku.Region.notify(d, [ {:display, display}, {:west , f} , {:east, e} , {:north, a} , {:south, g}])
    Sudoku.Region.notify(e, [ {:display, display}, {:west , d} , {:east, f} , {:north, b} , {:south, h}])
    Sudoku.Region.notify(f, [ {:display, display}, {:west , e} , {:east, d} , {:north, c} , {:south, i}])
    Sudoku.Region.notify(g, [ {:display, display}, {:west , i} , {:east, h} , {:north, d} , {:south, a}])
    Sudoku.Region.notify(h, [ {:display, display}, {:west , g} , {:east, i} , {:north, e} , {:south, b}])
    Sudoku.Region.notify(i, [ {:display, display}, {:west , h} , {:east, g} , {:north, f} , {:south, c}])

    result = receive do
      :done -> :ok
      after 5000 -> :notok
    end

    { result , Sudoku.Display.received(display) }
  end
end
