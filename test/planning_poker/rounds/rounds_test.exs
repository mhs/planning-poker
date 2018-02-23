defmodule PlanningPokerWeb.RoundsTest do
  use PlanningPoker.DataCase

  alias PlanningPoker.Games.{GamePlayer}
  alias PlanningPoker.Repo
  alias PlanningPoker.Rounds
  alias PlanningPoker.Factory

  describe "rounds" do
    test "estimates shows" do
      game = Factory.insert(:game)
      u1 = Factory.insert(:user)
      u2 = Factory.insert(:user)
      gp1 = Repo.insert!(%GamePlayer{user_id: u1.id, game_id: game.id})
      gp2 = Repo.insert!(%GamePlayer{user_id: u2.id, game_id: game.id})
      round = Factory.insert(:round, game: game)

      Factory.insert(:estimate, round: round, game_player: gp1)
      Factory.insert(:estimate, round: round, game_player: gp2)

      estimates = Rounds.estimates(round)
      assert Enum.count(estimates) == 2
    end

    test "current_estimate" do
      round = Factory.insert(:round)
      user = Factory.insert(:user)
      gp1 = Repo.insert!(%GamePlayer{user_id: user.id, game_id: round.game.id})

      e = Factory.insert(:estimate, game_player: gp1, round: round)

      found_estimate = Rounds.current_estimate(round, user)
      assert found_estimate.id == e.id
    end
  end
end
