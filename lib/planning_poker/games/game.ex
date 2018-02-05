defmodule PlanningPoker.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.{Game}

  schema "games" do
    field(:name, :string)
    field(:status, :string)
    has_many(:rounds, PlanningPoker.Rounds.Round)
    many_to_many(:players, PlanningPoker.Accounts.User, join_through: "game_players")

    timestamps()
  end

  def possible_status do
    ["open", "closed"]
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
    |> validate_inclusion(:status, possible_status())
  end
end
