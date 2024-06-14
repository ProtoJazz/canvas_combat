defmodule CanvasCombat.GameState do
  defstruct players: [],
            game_phase: CanvasCombat.GamePhase.new(),
            test_art: "",
            leader: nil,
            draw_time: 120,
            write_time: 120,
            game_id: nil,
            next_phase_time: nil
end
