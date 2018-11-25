defmodule LaniWeb.Admin.PageController do
  use LaniWeb, :controller

  alias Lani.Accounts
  alias Lani.Events

  plug :load_categories when action in [:index, :new, :create, :edit, :update]

  def index(conn, _params) do
  	users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

   defp load_categories(conn, _) do
    assign(conn, :categories, Events.list_alphabetical_categories())
  end

end
