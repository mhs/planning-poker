defmodule PlanningPoker.Repo.Migrations.CreateEstimates do
  use Ecto.Migration

  def change do
    create table(:estimates) do
      add :amount, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :round_id, references(:rounds, on_delete: :nothing)

      timestamps()
    end

    create index(:estimates, [:user_id])
    create index(:estimates, [:round_id])
  end
end
