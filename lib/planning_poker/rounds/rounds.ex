# The Rounds context
defmodule PlanningPoker.Rounds do
  alias PlanningPoker.Repo
  alias PlanningPoker.Rounds.{Estimate, Round}
  require Ecto.Query

  def create_estimate(round_id, user_id, amount) do
    %Estimate{}
    |> Estimate.changeset(%{round_id: round_id, user_id: user_id, amount: amount})
    |> Repo.insert()
  end

  def rescind_estimate(round, user) do
    Ecto.Query.from(e in Estimate, where: [round_id: ^round.id, user_id: ^user.id])
    |> Repo.delete()
  end

  # Mark the round closed to show all estimates?
  def reveal_all_estimates() do
  end

  def next_round(game_id) do
    # close all existing rounds
    # create a new open round
    create_round(%{game_id: game_id, status: "open"})
  end

  # Retrieves players' estimates for the round or shows a 'pending' estimate
  def displayable_estimates(nil, _), do: []
  def displayable_estimates(round, players) do
    existing_estimates = Repo.all(Ecto.assoc(round, :estimates)) |> Repo.preload(:user)
    player_ids = players |> Enum.map(& &1.id) |> MapSet.new()
    existing_estimate_ids = existing_estimates |> Enum.map(& &1.user_id) |> MapSet.new()

    pending_estimates =
      MapSet.difference(player_ids, existing_estimate_ids)
      |> Enum.map(fn id ->
        %Estimate{round_id: round,  user: Enum.find(players, &(&1.id == id)), pending: true}
      end)

    existing_estimates ++ pending_estimates
  end

  defp create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  def set_estimate(round, user, amount) do
    current_estimate(round, user)
    |> Ecto.Changeset.put_change(amount: amount)
    |> Repo.insert_or_update()
  end

  # Find or create the current user's estimate for the round
  def current_estimate(nil, _), do: nil
  def current_estimate(round, user) do
    case Repo.get_by(Estimate, round_id: round.id, user_id: user.id) do
      nil ->
        %Estimate{}
        |> Estimate.changeset(%{round_id: round.id, user_id: user.id})

      estimate ->
        Ecto.Changeset.change(estimate)
    end
  end
end
