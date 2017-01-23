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
end
