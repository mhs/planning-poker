defmodule PlanningPoker.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.{Game, GamePlayer}
  alias PlanningPoker.Accounts.User


  schema "game_players" do
    belongs_to :user, User
    belongs_to :game, Game

    timestamps()
  end

  @doc false
  def changeset(%GamePlayer{} = player, attrs) do
    player
    |> cast(attrs, [])
    |> validate_required([])
  end
end
