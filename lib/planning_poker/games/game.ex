defmodule PlanningPoker.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.Game


  schema "games" do
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
