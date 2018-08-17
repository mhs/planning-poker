defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel

  intercept(["estimates_updated"])

  def join("game:" <> _game_id, %{"token" => token}, socket) do
    {:ok, resource, _claims} = PlanningPoker.Guardian.resource_from_token(token)
    {:ok, assign(socket, :user, %{email: resource.email})}
  end


  def handle_out("estimates_updated", payload, socket) do
    user = socket.assigns[:user]

    estimate_assigns = Map.put(payload, :current_user, user)
    new_info =  Phoenix.View.render_to_string(PlanningPokerWeb.GameView, "estimates.html", estimate_assigns)

    updated_payload = %{estimates: new_info, roundId: payload.round.id}
    push(socket, "estimates_updated", updated_payload)
    {:noreply, socket}
  end
end
