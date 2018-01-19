defmodule PlanningPokerWeb.Router do
  use PlanningPokerWeb, :router

  pipeline :auth do
    plug PlanningPoker.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  scope "/api/v1", PlanningPokerWebApi do
    pipe_through [:api, :auth]
  end

  scope "/", PlanningPokerWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/", PageController, :index
    post "/", PageController, :login
    post "/logout", PageController, :logout

    resources "/users", UserController do
      get "/user/current", UserController, :current, as: :current_user
      delete "/logout", AuthController, :delete
    end
  end

  scope "/", PlanningPokerWeb do
    pipe_through [:browser, :auth, :ensure_auth] # Use the default browser stack

    get "/secret", PageController, :secret
  end

  scope "/api/v1/auth", PlanningPokerWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlanningPokerWeb do
  #   pipe_through :api
  # end
end
