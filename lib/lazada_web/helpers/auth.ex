defmodule LazadaWeb.Helpers.Auth do
  @spec signed_in?(Plug.Conn.t()) :: false | nil | true
  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user)
    if user_id, do: !!Lazada.Accounts.get_user!(user_id)
  end
end
