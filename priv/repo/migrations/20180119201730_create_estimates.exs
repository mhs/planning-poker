defmodule PlanningPoker.Repo.Migrations.CreateEstimates do
  use Ecto.Migration

  def change do
    create table(:estimates) do
      add :amount, :string
      add :game_player_id, references(:game_players, on_delete: :delete_all)
      add :round_id, references(:rounds, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:estimates, [:round_id, :game_player_id])
  end
end
