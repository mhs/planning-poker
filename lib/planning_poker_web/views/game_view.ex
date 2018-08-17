defmodule PlanningPokerWeb.GameView do
  use PlanningPokerWeb, :view
  alias PlanningPoker.Rounds.{Estimate,Round}

  def vote_string(%Round{status: status}, %{email: current_user_email}, %Estimate{} = estimate) do
    email = estimate.user.email
    pending = Estimate.pending?(estimate)

    current_user? = email == current_user_email

    if current_user? do
      vote = case {status, pending} do
        {"closed", true} -> "did not vote"
        {"open", true} -> "has not voted"
        {_, false} -> "voted #{estimate.amount}"
      end
      [email, "(you)", " ", vote]
    else
      vote = case {status, pending} do
        {"closed", true} -> "did not vote"
        {"closed", false} -> "voted #{estimate.amount}"
        {"open", true} -> "has not voted"
        {"open", false} -> "has voted"
      end
      [email, " ", vote]
    end
  end
end
