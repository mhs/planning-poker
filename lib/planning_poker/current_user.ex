defmodule PlanningPoker.CurrentUser do

  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end
end
