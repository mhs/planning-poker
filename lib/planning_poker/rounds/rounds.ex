# The Rounds context
defmodule PlanningPoker.Rounds do
  alias PlanningPoker.Repo
  alias PlanningPoker.Rounds.Estimate

  def create_estimate(round, user, value) do
    %Estimate{}
    |> Estimate.changeset(%{round_id: round.id, user_id: user.id, value: value})
    |> Repo.insert()
  end

  def rescind_estimate(round, user) do
    Ecto.Query.from(e in Estimate, where: [round_id: e.round_id, user_id: e.user_id])
    |> Repo.delete()
  end

  # Mark the round closed to show all estimates?
  def reveal_all_estimates(round) do
  end

  def next_round(game_id) do
    # close all existing rounds
    # create a new open round
    create_round(%{game_id: game_id, status: "open"})
  end

  # Retrieves players' estimates for the round or shows a 'pending' estimate
  def displayable_estimates(round, players) do
    existing_estimates = Ecto.assoc(round, :estimates)
    player_ids = players |> Enum.map(&(&1.id)) |> MapSet.new()
    existing_estimate_ids = existing_estimates |> Enum.map(&(&1.user_id)) |> MapSet.new()

    pending_estimates = MapSet.difference(player_ids, existing_estimate_ids)
    |> Enum.map(fn id -> %Round{round_id: round.id, user_id: id, pending: true} end)
  end

  defp create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end
end
