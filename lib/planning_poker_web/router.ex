defmodule PlanningPokerWeb.Router do
  use PlanningPokerWeb, :router

  pipeline :auth do
    plug(PlanningPoker.Accounts.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json", "json-api"])
    plug(JaSerializer.Deserializer)
  end

  scope "/api/v1", PlanningPokerWebApi do
    pipe_through([:api, :auth])
  end

  scope "/", PlanningPokerWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    post("/", PageController, :login)
    post("/logout", PageController, :logout)

    resources "/users", UserController do
      get("/user/current", UserController, :current, as: :current_user)
      delete("/logout", AuthController, :delete)
    end
  end

  scope "/", PlanningPokerWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth, :ensure_auth])

    resources "/games", GameController do
      post("/new_round", GameController, :new_round, as: :new_round)
      post("/join", GameController, :join, as: :join)
      post("/estimate", GameController, :join, as: :estimate)
    end

    resources("/rounds", RoundController)
    get("/secret", PageController, :secret)
  end

  scope "/api/v1/auth", PlanningPokerWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
  end

  def log(conn, s) do
    IO.puts("---plug #{s}")
    IO.inspect(conn)
    conn
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlanningPokerWeb do
  #   pipe_through :api
  # end
end
