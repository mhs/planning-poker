defmodule PlanningPoker.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.Player


  schema "players" do
    field :game_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [])
    |> validate_required([])
  end
end
