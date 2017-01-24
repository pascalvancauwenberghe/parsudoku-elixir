defmodule ParSudokuTest do
  use ExUnit.Case
  doctest ParSudoku

  test "Parsudoku creates 3x3 Region structure" do
    {display, regions} = ParSudoku.new([ { "A" , {1,2,3}} ])

    assert length(regions) == 9
    region_a = Enum.at(regions,0)

    assert Sudoku.Region.known_values(region_a) == [ {1,2,3} ]

    assert !Sudoku.Display.solved?(display)
  end

  test "Parsudoku creates easy sudoku" do
    {display, regions} = ParSudoku.new(simple_sudoku())

    region_i = Enum.at(regions,8)

    assert Sudoku.Region.known_values(region_i) == [ {1,1,2}, {1,3,8}, {3,1,5}, {3,3,3} ]
    assert !Sudoku.Display.solved?(display)
  end
  
  test "Parsudoku starts constraint satisfaction" do
    {display, regions} = ParSudoku.new(simple_sudoku())

    ParSudoku.solve({display,regions})

    Process.sleep(5000)
    IO.inspect length(Sudoku.Display.received(display))

    assert Sudoku.Display.solved?(display)
  end

  test "Helper function to initialize a row of 3 regions" do
    initial = three_regions(?A, ["1_2|546|_3_",
                                 "___|2__|__6",
                                 "5_9|_71|_4_"])

    assert initial == [ { "A" ,{1, 1, 1}}, {"A", {1, 3, 2}}, {"A", {3, 1, 5}}, {"A", {3, 3, 9}} , 
                        { "B", {1, 1, 5}}, {"B", {1, 2, 4}}, {"B", {1, 3, 6}}, {"B", {2, 1, 2}}, {"B", {3, 2, 7}}, {"B", {3, 3, 1}}, 
                        { "C", {1, 2, 3}}, {"C", {2, 3, 6}}, {"C", {3, 2, 4}}]
  
  end


  test "Helper function to initialize a 3x3 regions full Sudoku" do
    assert simple_sudoku() ==  
       [{"A", {1, 1, 1}}, {"A", {1, 3, 2}}, {"A", {3, 1, 5}}, {"A", {3, 3, 9}}, 
        {"B", {1, 1, 5}}, {"B", {1, 2, 4}}, {"B", {1, 3, 6}}, {"B", {2, 1, 2}}, {"B", {3, 2, 7}}, {"B", {3, 3, 1}}, 
        {"C", {1, 2, 3}}, {"C", {2, 3, 6}}, {"C", {3, 2, 4}}, 
        {"D", {3, 1, 9}}, {"D", {3, 3, 6}},
        {"E", {1, 1, 9}}, {"E", {1, 2, 3}}, {"E", {2, 1, 1}}, {"E", {2, 3, 8}}, {"E", {3, 2, 2}}, {"E", {3, 3, 4}},
        {"F", {1, 1, 6}}, {"F", {1, 3, 4}}, 
        {"G", {1, 2, 7}}, {"G", {2, 1, 3}}, {"G", {3, 2, 4}},
        {"H", {1, 1, 4}}, {"H", {1, 2, 5}}, {"H", {2, 3, 2}}, {"H", {3, 1, 6}}, {"H", {3, 2, 9}}, {"H", {3, 3, 7}}, 
        {"I", {1, 1, 2}}, {"I", {1, 3, 8}}, {"I", {3, 1, 5}}, {"I", {3, 3, 3}}] 
  end

  # http://www.websudoku.com/?level=1&set_id=7439188610
  defp simple_sudoku do
    parse_sudoku(["1_2|546|_3_",
                  "___|2__|__6",
                  "5_9|_71|_4_",
                  "-----------",
                  "___|93_|6_4",
                  "___|1_8|___",
                  "9_6|_24|___",
                  "-----------",
                  "_7_|45_|2_8",
                  "3__|__2|___",
                  "_4_|697|5_3"])  end

  defp parse_sudoku([row1,row2,row3,_separator1,row4,row5,row6,_separator2,row7,row8,row9]) do
    three_regions(?A,[row1,row2,row3]) ++
    three_regions(?D,[row4,row5,row6]) ++
    three_regions(?G,[row7,row8,row9])  
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
