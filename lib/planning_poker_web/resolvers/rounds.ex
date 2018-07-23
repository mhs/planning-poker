defmodule PlanningPokerWeb.Resolvers.Rounds do
  def find_round(_parent, %{id: id}, _) do
    {:ok, PlanningPoker.Rounds.get_round!(id)}
  end

  def update_estimate(_parent, args, _context) do
    PlanningPoker.Rounds.update_estimate(args)
  end
end
