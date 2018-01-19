defmodule PlanningPoker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :game_id, references(:games, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:players, [:game_id])
    create index(:players, [:user_id])
  end
end
