defmodule Sudoku.Notifyable do
  @moduledoc """
    A Notifyable can be notified of a result from a `Sudoku.Region`.
    It keeps the received messages and knows when it is solved

  """

  @doc "Call this method to notify that the from_region has discovered a solution"
  @callback found(pid,role :: atom, from_region :: Sudoku.Region.region_name, Sudoku.Grid.result) :: :ok

  @doc "Returns the list of found notifications, in the order they were received"
  @callback received(pid) :: [ {:found , role :: atom , from_region :: Sudoku.Region.region_name , Sudoku.Grid.result } ]

  @doc "Is this notifyable solved?, are all of its values known?"
  @callback solved?(pid) :: boolean
end
