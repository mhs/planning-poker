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
    |> render(PlanningPoker.ErrorView, "401.json-api")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.basic_info(auth) do
      {:ok, user} ->
        sign_in_user(conn, %{"user" => user})
    end

    case User.basic_info(auth) do
      {:ok, user} ->
        conn
        |> render(PlanningPoker.UserView, "show.json-api", %{data: user})

      {:error} ->
        conn
        |> put_status(401)
        |> render(PlanningPoker.ErrorView, "401.json-api")
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    try do
      # try to get exactly one user from the db whose email matches
      # that of the login request
      user = PlanningPoker.Accounts.user_by_email(user.email)

      cond do
        true ->
          # Success, create a JWT
          {:ok, _jwt, _} = PlanningPoker.Guardian.encode_and_sign(user, :token)
          auth_conn = PlanningPoker.Guardian.Plug.sign_in(conn, user)
          jwt = PlanningPoker.Guardian.Plug.current_token(auth_conn)
          {:ok, _claims} = PlanningPoker.Guardian.Plug.current_claims(auth_conn)

          # return token to client
          auth_conn
          |> put_resp_header("authorization", "Bearer #{jwt}")
          |> json(%{access_token: jwt})

        false ->
          # not successful
          conn
          |> put_status(401)
          |> render()
          |> render(PlanningPoker.ErrorView, "401.json-api")
      end
    rescue
      e ->
        IO.inspect(e)

        sign_up_user(conn, %{"user" => user})
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    changeset = User.changeset %User{}, %{email: user.email,
                                          avatar: user.avatar,
                                          first_name: user.first_name,
                                          last_name: user.last_name,
                                          auth_provider: "google"}
    case Repo.insert changeset do
      {:ok, user} ->
        # Encode a JWT
        { :ok, jwt, _ } = PlanningPoker.Guardian.encode_and_sign(user, :token)
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{access_token: jwt}) # Return token to the client
      {:error, _} ->
        conn
        |> put_status(422)
        |> render(PlanningPoker.ErrorView, "422.json-api")
    end
  end

  def unauthenticated(conn, _) do
    conn
    |> put_status(401)
    |> render(PlanningPoker.ErrorView, "401.json-api")
  end

  def unauthorized(conn, _) do
    conn
    |> put_status(403)
    |> render(PlanningPoker.ErrorView, "403.json-api")
  end

  def already_authenticated(conn, _) do
    conn
    |> put_status(200)
    |> render(PlanningPoker.ErrorView, "200.json-api")
  end

  def no_resource(conn, _) do
    conn
    |> put_status(404)
    |> render(PlanningPoker.ErrorView, "404.json-api")
  end
end
