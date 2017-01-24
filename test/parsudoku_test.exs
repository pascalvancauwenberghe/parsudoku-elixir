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
    {display, regions} = ParSudoku.new(ParSudoku.parse_sudoku(simple_sudoku_problem()))

    region_i = Enum.at(regions,8)

    assert Sudoku.Region.known_values(region_i) == [ {1,1,2}, {1,3,8}, {3,1,5}, {3,3,3} ]
    assert !Sudoku.Display.solved?(display)
  end
  
  test "Parsudoku starts constraint satisfaction" do
    {display,regions} = ParSudoku.new(ParSudoku.parse_sudoku(simple_sudoku_problem()))

    {result,received} = ParSudoku.solve({display,regions})

    assert result == :ok
    assert length(received) == 81
    assert ParSudoku.generate_sudoku(received) == simple_sudoku_solution()
  end

  test "Helper function to initialize a 3x3 regions full Sudoku" do
    assert ParSudoku.parse_sudoku(simple_sudoku_problem()) ==  
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

  test "Helper function to convert list of results back into Sudoku" do
    results = ParSudoku.parse_sudoku(simple_sudoku_problem())  

    assert ParSudoku.generate_sudoku(results) == simple_sudoku_problem()
  end

  # Sudoku from http://www.websudoku.com/?level=1&set_id=7439188610
  def simple_sudoku_problem do
    ["1_2|546|_3_",
     "___|2__|__6",
     "5_9|_71|_4_",
     "-----------",
     "___|93_|6_4",
     "___|1_8|___",
     "9_6|_24|___",
     "-----------",
     "_7_|45_|2_8",
     "3__|__2|___",
     "_4_|697|5_3"]
  end

  def simple_sudoku_solution do
   ["182|546|739", 
    "734|289|156", 
    "569|371|842", 
    "-----------", 
    "817|935|624",
    "423|168|975", 
    "956|724|381", 
    "-----------", 
    "671|453|298", 
    "395|812|467",
    "248|697|513"]
  end


end
