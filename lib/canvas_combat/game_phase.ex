defmodule CanvasCombat.GamePhase do
  @moduledoc """
  This module is responsible for managing the game phases.
  """

  @type t :: :lobby | :draw | :write | :duel | :end

  def new(), do: :setup

  def next(:setup), do: :play
  def next(:play), do: :end
  def next(:end), do: :setup
end
