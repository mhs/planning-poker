defmodule PlanningPoker.Rounds.Estimate do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Rounds.Estimate

  schema "estimates" do
    field(:amount, :string)
    belongs_to(:user, PlanningPoker.Accounts.User)
    belongs_to(:round, PlanningPoker.Rounds.Round)

    timestamps()
  end

  @valid_amounts ~w(1 2 3 5 8 13 pass)

  @doc false
  def changeset(%Estimate{} = estimate, attrs) do
    estimate
    |> cast(attrs, [:amount, :user_id, :round_id])
    |> validate_required([:amount, :user_id, :round_id])
    |> validate_inclusion(:amount, @valid_amounts)
  end

  def pending_estimate(attrs) do
    %Estimate{}
    |> cast(attrs, [:user_id, :round_id])
    |> validate_required([:user_id, :round_id])
  end

  def pending?(estimate) do
    estimate.amount == nil
  end
end
