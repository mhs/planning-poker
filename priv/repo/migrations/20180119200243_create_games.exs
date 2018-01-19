defmodule PlanningPoker.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :status, :string

      timestamps()
    end

  end
end
