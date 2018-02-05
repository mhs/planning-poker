defmodule PlanningPokerWeb.AuthController do
  use PlanningPokerWeb, :controller
  plug(Ueberauth)

  alias PlanningPoker.Accounts.User
  alias PlanningPoker.Repo

  plug(:scrub_params, "user" when action in [:sign_in_user])

  def request(_params) do
  end

  # Sign out the user
  def delete(conn, _params) do
    conn
    |> put_status(200)
    |> PlanningPoker.Guardian.Plug.sign_out(conn)
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    # this callback is called when the user denies the app's request for data
    # from the oauth provider
    conn
    |> put_status(401)
    |> render(PlanningPokerWeb.ErrorView, "401.json-api")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.basic_info(auth) do
      {:ok, user} ->
        sign_in_user(conn, %{"user" => user})

      {:error, _} ->
        conn
        |> put_status(401)
        |> render(PlanningPokerWeb.ErrorView, "401.json-api")
    end
  end

  def sign_in_user(conn, %{"user" => oauth_user}) do
    # try to get exactly one user from the db whose email matches
    # that of the login request
    user = PlanningPoker.Accounts.user_by_email(oauth_user.email)

    if user do
      IO.puts("found user")

      cond do
        true ->
          conn
          |> PlanningPoker.Guardian.Plug.sign_in(user)
          |> redirect(to: "/")

        false ->
          # not successful
          IO.puts("uuuh false")

          conn
          |> put_status(401)
          |> render(PlanningPokerWeb.ErrorView, "401.json-api")
      end
    else
      sign_up_user(conn, %{"user" => oauth_user})
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    changeset =
      User.changeset(%User{}, %{
        email: user.email,
        avatar: user.avatar,
        first_name: user.first_name,
        last_name: user.last_name,
        auth_provider: "google"
      })

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> PlanningPoker.Guardian.Plug.sign_in(user)
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_status(422)
        |> render(PlanningPokerWeb.ErrorView, "422.json-api")
    end
  end

  def unauthenticated(conn, _) do
    conn
    |> put_status(401)
    |> render(PlanningPokerWeb.ErrorView, "401.json-api")
  end

  def unauthorized(conn, _) do
    conn
    |> put_status(403)
    |> render(PlanningPokerWeb.ErrorView, "403.json-api")
  end

  def already_authenticated(conn, _) do
    conn
    |> put_status(200)
    |> render(PlanningPokerWeb.ErrorView, "200.json-api")
  end

  def no_resource(conn, _) do
    conn
    |> put_status(404)
    |> render(PlanningPokerWeb.ErrorView, "404.json-api")
  end
end
