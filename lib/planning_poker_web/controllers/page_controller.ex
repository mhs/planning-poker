defmodule PlanningPokerWeb.PageController do
  use PlanningPokerWeb, :controller

  alias PlanningPoker.Accounts
  alias PlanningPoker.Accounts.User
  alias PlanningPoker.Guardian

  def index(conn, _params) do
    changeset = PlanningPoker.Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    message =
      if maybe_user != nil do
        "Welcome back #{maybe_user.email}!"
      else
        "No one is logged in"
      end

    games =
    if maybe_user != nil do
      PlanningPoker.Repo.all(Ecto.assoc(maybe_user, :games))
    else
      []
    end

    conn
    |> put_flash(:info, message)
    |> render(
      "index.html",
      changeset: changeset,
      maybe_user: maybe_user,
      games: games,
      action: page_path(conn, :login)
    )
  end

  def login(conn, %{"user" => %{"email" => email}}) do
    Accounts.authenticate_user(email)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    IO.inspect(user)

    conn
    |> put_flash(:success, "Logged in")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _params) do
    IO.inspect(conn)

    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :index))
  end

  def secret(conn, _) do
    render(conn, "secret.html")
  end
end
