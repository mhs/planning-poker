defmodule PlanningPoker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:game_players) do
      add :game_id, references(:games, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:game_players, [:game_id, :user_id])
  end
end
