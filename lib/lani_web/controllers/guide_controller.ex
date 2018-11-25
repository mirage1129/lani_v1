defmodule LaniWeb.GuideController do
  use LaniWeb, :controller

  alias Lani.Events
  alias Lani.Events.Guide

  plug :authenticate_editor when action in [:new, :create, :edit, :update, :delete]
  plug :load_categories when action in [:new, :edit, :index]

  defp load_categories(conn, _) do
    assign(conn, :categories, Events.list_alphabetical_categories())
  end

  def index(conn, _params) do
    guides = Events.list_guides()
    render(conn, "index.html", guides: guides)
  end

  def new(conn, _params) do
    changeset = Events.change_guide(%Guide{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"guide" => guide_params}) do
    case Events.create_guide(guide_params) do
      {:ok, guide} ->
        conn
        |> put_flash(:info, "Guide created successfully.")
        |> redirect(to: Routes.guide_path(conn, :show, guide))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    guide = Events.get_guide!(id)
    render(conn, "show.html", guide: guide)
  end

  def edit(conn, %{"id" => id}) do
    guide = Events.get_guide!(id)
    changeset = Events.change_guide(guide)
    render(conn, "edit.html", guide: guide, changeset: changeset)
  end

  def update(conn, %{"id" => id, "guide" => guide_params}) do
    guide = Events.get_guide!(id)

    case Events.update_guide(guide, guide_params) do
      {:ok, guide} ->
        conn
        |> put_flash(:info, "Guide updated successfully.")
        |> redirect(to: Routes.guide_path(conn, :show, guide))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", guide: guide, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    guide = Events.get_guide!(id)
    {:ok, _guide} = Events.delete_guide(guide)

    conn
    |> put_flash(:info, "Guide deleted successfully.")
    |> redirect(to: Routes.guide_path(conn, :index))
  end
end
