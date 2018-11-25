defmodule LaniWeb.Admin.PageController do
  use LaniWeb, :controller

  alias Lani.Accounts
  alias Lani.Events

  plug :authenticate_admin when action in [:index]
  plug :load_categories when action in [:index]

  def index(conn, _params) do
  	users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  defp load_categories(conn, _) do
    assign(conn, :categories, Events.list_alphabetical_categories())
  end
  

end
