defmodule LaniWeb.Router do
  use LaniWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LaniWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # guest zone
  scope "/", LaniWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :show
    resources "/users", UserController, only: [:new, :create, :show]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/guides", GuideController
  end

  # admin zone
  scope "/admin", LaniWeb.Admin, as: :admin do
    pipe_through [:browser]
    resources "/", PageController, only: [:index]
    resources "/users", UserController, only: [:edit, :update]
    resources "/category", CategoryController, only: [:edit, :delete, :update, :new, :create]
  end

end
