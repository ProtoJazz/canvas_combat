defmodule CanvasCombatWeb.Plugs.UserPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user_id = user_id || UUID.uuid4()
    put_session(conn, :user_id, user_id)
  end
end
