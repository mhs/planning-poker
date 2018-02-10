defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> game_id, %{"token" => token}, socket) do
    IO.puts "joining game"
    {:ok, resource, claims} = PlanningPoker.Guardian.resource_from_token(token)
    IO.inspect resource
    {:ok, socket}
  end
end
