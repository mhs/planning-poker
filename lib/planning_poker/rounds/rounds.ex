# The Rounds context
defmodule PlanningPoker.Rounds do
  alias PlanningPoker.Repo
  alias PlanningPoker.Games
  alias PlanningPoker.Games.GamePlayer
  alias PlanningPoker.Rounds.{Estimate, Round}
  import Ecto.Query

  def get_round!(id), do: Repo.get!(Round, id)

  def rescind_estimate(round, user) do
    # TODO: get game player for user?
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
      from(r in Round, where: [game_id: ^game_id, status: "open"])
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

  def create_pending_estimate(round, %GamePlayer{id: player_id}) do
    %{game_player_id: player_id, round_id: round.id}
    |> Estimate.pending_estimate()
    |> Repo.insert()
  end

  # Retrieves players' estimates for the round or shows a 'pending' estimate
  def estimates(nil), do: []

  def estimates(round = %Round{}) do
    (from e in Ecto.assoc(round, :estimates), preload: :user) |> Repo.all()
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
    q = Ecto.Query.from e in Estimate,
      join: g in assoc(e, :game_player),
      join: u in assoc(g, :user),
      where: u.id == ^user.id,
      where: e.round_id == ^round.id


    case q |> Repo.one do
      nil ->
        game_player = Ecto.assoc(user, :game_players)
        |> where([p], p.game_id == ^round.game_id)
        |> Repo.one

        %Estimate{round_id: round.id, game_player_id: game_player.id}
      %Estimate{} = e -> e
    end
  end
end
