defmodule CreditCardLedgerHttp.Router do
  use Plug.Router
  import Plug.Conn

  plug(:fetch_query_params)
  plug(:match)
  plug(:dispatch)

  get("/", do: CreditCardLedgerHttp.Handler.index(conn))

end
