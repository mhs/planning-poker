defmodule PlanningPoker.Rounds.Estimate do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Rounds.Estimate

  schema "estimates" do
    field(:amount, :string)
    belongs_to(:game_player, PlanningPoker.Games.GamePlayer)
    has_one(:user, through: [:game_player, :user])
    belongs_to(:round, PlanningPoker.Rounds.Round)

    timestamps()
  end

  @valid_amounts ~w(1 2 3 5 8 13 pass)

  @doc false
  def changeset(%Estimate{} = estimate, attrs) do
    estimate
    |> cast(attrs, [:amount, :game_player_id, :round_id])
    |> validate_required([:amount, :game_player_id, :round_id])
    |> validate_inclusion(:amount, @valid_amounts)
  end

  @spec pending_estimate(%{game_player_id: any(), round_id: any()}) :: any()
  def pending_estimate(attrs) do
    %Estimate{}
    |> cast(attrs, [:game_player_id, :round_id])
    |> validate_required([:game_player_id, :round_id])
  end

  def pending?(estimate) do
    estimate.amount == nil
  end
end
