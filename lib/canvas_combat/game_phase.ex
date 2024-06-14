defmodule CanvasCombat.GamePhase do
  @moduledoc """
  This module is responsible for managing the game phases.
  """

  @type t :: :lobby | :draw | :write | :duel | :end

  def new(), do: :lobby
end
