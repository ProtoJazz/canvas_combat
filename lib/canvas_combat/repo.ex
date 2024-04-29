defmodule CanvasCombat.Repo do
  use Ecto.Repo,
    otp_app: :canvas_combat,
    adapter: Ecto.Adapters.Postgres
end
