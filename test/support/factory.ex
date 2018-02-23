defmodule PlanningPoker.Factory do
  use ExMachina.Ecto, repo: PlanningPoker.Repo

  alias PlanningPoker.Games.GamePlayer
  alias PlanningPoker.Games.Game
  alias PlanningPoker.Accounts.User
  alias PlanningPoker.Rounds.{Estimate, Round}

  def game_factory do
    %Game{name: sequence("game"), status: "open"}
  end

  def user_factory do
    %User{
      first_name: sequence("first_name"),
      last_name: sequence("last_name"),
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def round_factory do
    %Round{
      status: "open",
      game: build(:game),
    }
  end

  def game_player_factory do
    %GamePlayer{
      user: build(:user),
      game: build(:game),
    }
  end

  def with_round(game) do
    insert(:round, game: game)
    game
  end

  def estimate_factory do
    %Estimate{
      amount: "1",
    }
  end
end
