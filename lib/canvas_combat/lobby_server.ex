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

  def handle_cast({:drawing, drawing}, state) do
    {:noreply, %{state | test_art: drawing}}
  end
end
