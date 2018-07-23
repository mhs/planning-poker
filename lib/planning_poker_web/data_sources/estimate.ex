defmodule PlanningPokerWeb.DataSources.Estimate do
  def data() do
    Dataloader.Ecto.new(PlanningPoker.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
