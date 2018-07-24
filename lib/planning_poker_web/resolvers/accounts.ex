defmodule PlanningPokerWeb.Resolvers.Accounts do
  def find_user(_parent, %{id: id}, _resolution) do
    {:ok, PlanningPoker.Accounts.get_user!(id)}
  end

  def login_user(_parent, %{email: email}, _resolution) do
    PlanningPoker.Accounts.new_token_for_user(email)
  end
end
