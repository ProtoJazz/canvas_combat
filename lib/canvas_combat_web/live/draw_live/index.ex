defmodule CanvasCombatWeb.DrawLive.Index do
  use CanvasCombatWeb, :live_view
  alias CanvasCombat.LobbyServer
  alias CanvasCombat.Game.Draw

  @impl true
  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    Process.send_after(self(), :timer, 30_000)
    {:ok, assign(socket, user_id: user_id)}
  end

  def handle_params(%{"game_id" => game_id} = _params, _uri, socket) do
    if connected?(socket), do: subscribe(game_id)

    socket =
      socket
      |> assign_game(game_id)

    {:noreply, socket}
  end

  defp assign_game(socket, game_id) do
    socket
    |> assign(game_id: game_id)
    |> assign_game()
  end

  defp assign_game(%{assigns: %{game_id: game_id, user_id: user_id}} = socket) do
    try do
      game = GenServer.call(via_tuple(game_id), :game)
      IO.inspect(game)
      assign(socket, state: game)
    catch
      :exit, _ ->
        {:ok, _pid} =
          DynamicSupervisor.start_child(
            CanvasCombat.GameSupervisor,
            {LobbyServer,
             name: via_tuple(game_id),
             game_phase: CanvasCombat.GamePhase.new(),
             players: [user_id],
             game_id: game_id,
             leader: user_id}
          )

        game = GenServer.call(via_tuple(game_id), :game)
        IO.inspect(game)
        assign(socket, state: game)
    end
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(CanvasCombat.PubSub, game_id)
  end

  defp via_tuple(name) do
    {:via, Registry, {CanvasCombat.GameRegistry, name}}
  end

  def handle_info(:timer, socket) do
    # Handle the :timer message and trigger the event on your page
    {:noreply, push_event(socket, "DrawingDone", %{})}
  end

  def handle_event("StartGame", _params, %{assigns: %{user_id: user_id, state: state}} = socket) do
    if(user_id == state.leader) do
      GenServer.call(via_tuple(socket.assigns.game_id), :start_game)
      :ok = Phoenix.PubSub.broadcast(CanvasCombat.PubSub, socket.assigns.game_id, :update)
    end

    {:noreply, socket}
  end

  def handle_event("DrawingSubmit", %{"drawing" => drawing} = params, socket) do
    if(socket.assigns.role != "master") do
      GenServer.cast(via_tuple(socket.assigns.game_id), {:drawing, drawing})
    end

    IO.puts("We got art")
    IO.inspect(drawing)
    IO.inspect(socket)
    :ok = Phoenix.PubSub.broadcast(CanvasCombat.PubSub, socket.assigns.game_id, :update)
    IO.inspect(socket)
    {:noreply, push_event(socket, "DrawThis", %{drawing: socket.assigns.state.test_art})}
  end

  def handle_info(:update, socket) do
    {:noreply, assign_game(socket)}
  end
end
