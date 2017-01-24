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

 def generate_sudoku(results) do
    generate_three_regions(?A,results) ++
    [ "-----------" ] ++
    generate_three_regions(?D,results) ++
    [ "-----------" ] ++
    generate_three_regions(?G,results)
  end

  def parse_sudoku([row1,row2,row3,_separator1,row4,row5,row6,_separator2,row7,row8,row9]) do
    three_regions(?A,[row1,row2,row3]) ++
    three_regions(?D,[row4,row5,row6]) ++
    three_regions(?G,[row7,row8,row9])  
  end

  defp generate_three_regions(first,results) do
    for row <- 1..3 do
      generate_region_row(first,row,results) <> "|" <>
      generate_region_row(first+1,row,results) <> "|" <>
      generate_region_row(first+2,row,results)
    end
  end

  defp generate_region_row(region_name,row,results) do
    region = << region_name >>
    for column <- 1..3 do
      item = Enum.find(results,fn({name,{thisrow,thiscolumn,_value}}) -> name == region && thisrow == row && thiscolumn == column end)
      case item do
        nil -> "_"
        {_name,{_row,_column,value}} -> << ?0 + value >>
      end
    end
    |> Enum.reduce("",fn(value,acc) -> acc <> value end)
  end

  defp three_regions(firstname,[row1,row2,row3]) do
    three_region_row(firstname,1,row1) ++
    three_region_row(firstname,2,row2) ++
    three_region_row(firstname,3,row3)
    |> Enum.sort_by(fn({name, { row, column, _value }}) -> name <> << ?1 + row , ?1 + column >> end)
  end

  defp three_region_row(firstname,row,description) do
    cell1 = String.slice(description,0..2)
    cell2 = String.slice(description,4..6)
    cell3 = String.slice(description,8..10)

    cell_values(firstname  ,row,cell1) ++
    cell_values(firstname+1,row,cell2) ++
    cell_values(firstname+2,row,cell3)
  end

  defp cell_values(name,row,description) do
    for column <- 1..3 do
      value = String.at(description,column-1)
      if value != "_", do: { << name >>, {row, column, String.to_integer(value) } }
    end
    |> Enum.filter(&(&1 != nil))
  end

end
