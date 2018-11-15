defmodule LaniWeb.PageController do
  use LaniWeb, :controller

  alias Lani.Events
  alias Lani.Events.Guide

  def index(conn, _params) do
    guides = Events.list_guides()
    render(conn, "index.html", guides: guides)
  end
end
