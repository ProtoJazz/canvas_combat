defmodule CanvasCombat.LobbyServer do
  alias CanvasCombat.GameState
  defstruct state: %GameState{}

  use GenServer, restart: :transient

  @timeout 600_000

  def start_link(options) do
    IO.inspect(options)
    initial_state = %GameState{} |> Map.merge(Map.new(options))
    GenServer.start_link(__MODULE__, initial_state, options)
  end

  def state(%CanvasCombat.LobbyServer{state: state}) do
    state
  end

  def handle_call(:game, _from, game) do
    {:reply, game, game, @timeout}
  end

  def handle_call(:start_game, _from, state) do
    if(state.game_phase == :lobby) do
      new_state = %{
        state
        | game_phase: :draw,
          next_phase_time: System.system_time(:second) + state.draw_time
      }

      IO.puts("Starting game")
      Process.send_after(self(), :advance_phase, state.draw_time)
      {:reply, new_state, new_state, @timeout}
    else
      {:reply, state, state, @timeout}
    end
  end

  def handle_info(:advance_phase, state) do
    if(state.game_phase == :draw) do
      new_state = %{
        state
        | game_phase: :write,
          next_phase_time: System.system_time(:second) + state.draw_time
      }

      IO.puts("Advancing to write phase")
      Process.send_after(self(), :advance_phase, state.write_time)
      :ok = Phoenix.PubSub.broadcast(CanvasCombat.PubSub, state.game_id, :update)
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:drawing, drawing}, state) do
    {:noreply, %{state | test_art: drawing}}
  end
end
