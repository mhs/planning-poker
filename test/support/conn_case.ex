defmodule PlanningPokerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import PlanningPokerWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint PlanningPokerWeb.Endpoint

      def guardian_login() do
        {:ok, user} = PlanningPoker.Repo.insert %PlanningPoker.Accounts.User{id: 1}
        guardian_login(user)
      end
      def guardian_login(user, token \\ :token, opts \\ []) do
        build_conn()
        |> bypass_through(PlanningPokerWeb.Router, [:browser])
        |> get("/")
        |> PlanningPoker.Guardian.Plug.sign_in(user)
        |> send_resp(200, "Flush the session yo")
        |> recycle()
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PlanningPoker.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PlanningPoker.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    if tags[:authenticated] do
      {:ok, test_user} = PlanningPoker.Repo.insert(%PlanningPoker.Accounts.User{id: 1})
      auth_conn = guardian_login(conn, test_user)
      {:ok, conn: auth_conn, user: test_user}
    else
      {:ok, conn: conn}
    end
  end

  def guardian_login(conn) do
    {:ok, user} = PlanningPoker.Repo.insert %PlanningPoker.Accounts.User{id: 1}
    guardian_login(user)
  end

  @endpoint PlanningPokerWeb.Endpoint

  def guardian_login(conn, user) do
    use Phoenix.ConnTest
    conn
    |> bypass_through(PlanningPokerWeb.Router, [:browser])
    |> get("/")
    |> PlanningPoker.Guardian.Plug.sign_in(user)
    |> send_resp(200, "Flush the session yo")
    |> recycle()
  end

end
