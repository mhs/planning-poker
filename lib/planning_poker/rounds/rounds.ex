# The Rounds context
defmodule PlanningPoker.Rounds do
  alias PlanningPoker.Repo
  alias PlanningPoker.Games
  alias PlanningPoker.Rounds.{Estimate, Round}
  require Ecto.Query

  def get_round!(id), do: Repo.get!(Round, id)

  def rescind_estimate(round, user) do
    Ecto.Query.from(e in Estimate, where: [round_id: ^round.id, user_id: ^user.id])
    |> Repo.delete()
  end

  def close_round(round) do
    Round.changeset(round, %{status: "closed"})
    |> Repo.update()
  end

  def next_round(game_id) do
    players = Games.get_players(game_id)
    Repo.transaction(fn ->
      Ecto.Query.from(r in Round, where: [game_id: ^game_id, status: "open"])
      |> Repo.update_all(set: [status: "closed"])

      # create a new open round
      {:ok, new_round} = create_round(%{game_id: game_id, status: "open"})

      # make a new pending estimate for every player
      Enum.each(players, fn player ->
        %{user_id: player.id, round_id: new_round.id}
        |> Estimate.pending_estimate()
        |> Repo.insert()
      end)
    end)
  end

  def create_pending_estimate(game, player) do
    round = Games.current_round(game)
    %{user_id: player.id, round_id: round.id}
    |> Estimate.pending_estimate()
    |> Repo.insert()
  end

  # Retrieves players' estimates for the round or shows a 'pending' estimate
  def displayable_estimates(nil, _), do: []

  def displayable_estimates(round, players) do
    player_ids = Enum.map(players, &(&1.id))
    Ecto.assoc(round, :estimates)
    |> Ecto.Query.where([e], e.user_id in ^player_ids)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  defp create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  def set_estimate(round, user, amount) do
    current_estimate(round, user)
    |> Estimate.changeset(%{amount: amount})
    |> Repo.insert_or_update()
  end

  # Find or create the current user's estimate for the round
  def current_estimate(nil, _), do: nil

  def current_estimate(round, user) do
    Repo.get_by(Estimate, round_id: round.id, user_id: user.id)
  end
end
