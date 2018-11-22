defmodule LaniWeb.AdminController do
  use LaniWeb, :controller

  alias Lani.Accounts
  alias Lani.Accounts.User
  alias Lani.Events

  plug :authenticate_admin when action in [:index]
  plug :load_categories when action in [:index]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def delete(conn, %{"id" => id}) do
    category = Events.get_category!(id)
    {:ok, _category} = Events.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end

  defp load_categories(conn, _) do
		assign(conn, :categories, Events.list_alphabetical_categories())
	end

end