defmodule PlanningPokerWeb.Resolvers.Accounts do
  def find_user(_parent, %{id: id}, _resolution) do
    {:ok, PlanningPoker.Accounts.get_user!(id)}
  end
end
