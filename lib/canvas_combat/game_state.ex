defmodule CanvasCombat.GameState do
  defstruct players: [],
            game_phase: CanvasCombat.GamePhase.new(),
            test_art: ""
end
