defmodule LaniWeb.PageController do
  use LaniWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, _params) do
    render(conn, "about.html")
  end

end
