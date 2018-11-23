defmodule LaniWeb.UserController do
  use LaniWeb, :controller

  alias Lani.Accounts
  alias Lani.Accounts.User

  # plug :authenticate_admin when action in [:index, :show]

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> LaniWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.guide_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
