defmodule PlanningPokerWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    current_user = Guardian.Plug.current_resource(conn)
    IO.inspect(current_user, label: "current user")
    if current_user do
      %{current_user: current_user}
    else
      %{}
    end
  end
end
