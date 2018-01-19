defmodule PlanningPoker.Games.Estimate do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Games.Estimate


  schema "estimates" do
    field :amount, :string
    field :user_id, :id
    field :round_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Estimate{} = estimate, attrs) do
    estimate
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
