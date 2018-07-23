defmodule PlanningPokerWeb.GameView do
  use PlanningPokerWeb, :view
  alias PlanningPoker.Rounds.Estimate

  def vote_string(%{status: status}, %Estimate{} = estimate) do
    email = estimate.user.email
    pending = Estimate.pending?(estimate)

    vote =
      case {status, pending} do
        {"closed", true} -> "did not vote"
        {"closed", false} -> "voted #{estimate.amount}"
        {_, true} -> "has not voted"
        {_, false} -> "has voted"
      end

    [email, " ", vote]
  end
end
