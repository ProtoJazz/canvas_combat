defmodule CanvasCombatWeb.LandingPageLive.Index do
  use CanvasCombatWeb, :live_view

  alias CanvasCombat.Game
  alias CanvasCombat.Game.LandingPage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("start_lobby", _value, socket) do
    random_id = MnemonicSlugs.generate_slug(3)
    {:noreply, push_redirect(socket, to: "/draws?game_id=#{random_id}")}
  end
end
