defmodule LaniWeb.PageController do
  use LaniWeb, :controller

  alias Lani.Events
  alias Lani.Events.Guide

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
