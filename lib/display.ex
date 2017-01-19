defmodule Sudoku.Display do
  @moduledoc """
    A Display collects results from Regions

      iex> display = Sudoku.Display.new
      iex> Sudoku.Display.solved?(display)
      false

  """

  use GenServer

# Public API

  @doc "Construct a new Display with the given name and optional list of known values as {row,column,value}"
  def new do
    {:ok,pid} = GenServer.start_link( Sudoku.Display, [])
    pid
  end

  @doc "Returns whether included Grid is solved"
  def solved?(display) do
    GenServer.call(display,:solved?)
  end

# GenServer callbacks

  def handle_call(:solved?,_from,state) do
    {:reply ,  length(state) == 81 , state }
  end

 end
