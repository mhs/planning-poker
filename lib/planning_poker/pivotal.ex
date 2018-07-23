defmodule PlanningPoker.Pivotal do
  use HTTPoison.Base

  def headers(token) do
    ["X-TrackerToken": token, "Content-Type": "application/json"]
  end

  def token do
    Application.fetch_env!(:planning_poker, :pivotal_api_key)
  end

  def get_story do
    get(
      "https://www.pivotaltracker.com/services/v5/projects/2130373/stories/158267859",
      headers(token())
    )
  end
end
