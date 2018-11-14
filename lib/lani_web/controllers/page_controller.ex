defmodule LaniWeb.PageController do
  use LaniWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
