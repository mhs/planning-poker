defmodule PlanningPoker.Rounds.Round do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Rounds.{Estimate, Round}


  schema "rounds" do
    field :status, :string
    field :game_id, :id
    has_many :estimates, Estimate

    timestamps()
  end

  @possible_status ["open", "closed"]

  @doc false
  def changeset(%Round{} = round, attrs) do
    round
    |> cast(attrs, [:game_id, :status])
    |> validate_required([:game_id, :status])
    |> validate_inclusion(:status, @possible_status)
  end
end
