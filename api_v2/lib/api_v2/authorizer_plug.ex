defmodule ApiV2.Authorizer.Plug do
  require Logger
  import Plug.Conn
  @behaviour Plug
  def init(opts) do
    opts
  end

  def call(conn, opts) do
    authorizer = Keyword.get(opts, :authorizer, ApiV2.Authorizer)
    get_req_header(conn, "cookie")
    |> authorizer.authorize
    |> handle_authorization(conn)
  end

  defp handle_authorization({:authorized, user}, conn) do
    conn
    |> assign(:user, user)
  end
  defp handle_authorization(:unauthorized, conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt
  end
end
