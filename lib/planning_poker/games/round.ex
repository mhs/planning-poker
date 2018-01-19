defmodule PlanningPoker.Games.Round do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.Round


  schema "rounds" do
    field :status, :string
    field :game_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Round{} = round, attrs) do
    round
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
