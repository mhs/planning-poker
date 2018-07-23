defmodule PlanningPokerWeb.Router do
  use PlanningPokerWeb, :router

  pipeline :auth do
    plug(PlanningPoker.Accounts.Pipeline)
    plug(PlanningPoker.CurrentUser)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(:assign_token)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api" do
    pipe_through([:api, :auth])

    forward("/graphql", Absinthe.Plug, schema: PlanningPokerWeb.Schema)
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: PlanningPokerWeb.Schema)
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
      post("/close_round", GameController, :close_round, as: :close_round)
      post("/join", GameController, :join, as: :join)
      post("/leave", GameController, :leave, as: :leave)
      post("/estimate", GameController, :estimate, as: :estimate)
      put("/estimate", GameController, :estimate, as: :estimate)
    end

    resources("/rounds", RoundController)
    get("/secret", PageController, :secret)
  end

  scope "/api/v1/auth", PlanningPokerWeb do
    pipe_through(:browser)

    # Used in testing
    post("/test_sign_in", AuthController, :test_sign_in_user)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
  end

  def log(conn, s) do
    IO.puts("---plug #{s}")
    IO.inspect(conn)
    conn
  end

  def assign_token(conn, _) do
    token = PlanningPoker.Guardian.Plug.current_token(conn)

    conn
    |> assign(:user_token, token)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlanningPokerWeb do
  #   pipe_through :api
  # end
end
