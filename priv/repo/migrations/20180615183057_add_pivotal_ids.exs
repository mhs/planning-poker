defmodule PlanningPoker.Repo.Migrations.AddPivotalIds do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :pivotal_project_id, :string
    end

    alter table("rounds") do
      add :pivotal_story_id, :string
    end
  end
end
