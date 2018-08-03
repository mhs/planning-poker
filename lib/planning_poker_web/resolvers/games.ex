defmodule PlanningPokerWeb.Resolvers.Games do
  def list_games(_parent, _args, _resolution) do
    {:ok, PlanningPoker.Games.list_games()}
  end

  def find_game(_parent, %{id: id}, _resolution) do
    case PlanningPoker.Games.get_game(id) do
      nil -> {:error, "Game #{id} not found"}
      game -> {:ok, game}
    end

    {:ok, PlanningPoker.Games.get_game(id)}
  end

  def my_games(_parent, _args, %{context: %{current_user: user}}) do
    {:ok, PlanningPoker.Games.my_games(user)}
  end

  def my_games(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end
end
