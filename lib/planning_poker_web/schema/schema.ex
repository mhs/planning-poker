defmodule PlanningPokerWeb.Schema do
  alias PlanningPokerWeb.DataSources
  use Absinthe.Schema
  import_types(PlanningPokerWeb.Schema.Types)

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(DataSources.Round, DataSources.Round.data())
      |> Dataloader.add_source(DataSources.Estimate, DataSources.Estimate.data())
      |> Dataloader.add_source(DataSources.User, DataSources.User.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    @desc "Get all games"
    field :games, list_of(:game) do
      resolve(&PlanningPokerWeb.Resolvers.Games.list_games/3)
    end

    @desc "Get all games for the current user"
    field :my_games, non_null(list_of(:game)) do
      resolve(&PlanningPokerWeb.Resolvers.Games.my_games/3)
    end

    @desc "Get a game"
    field :game, :game do
      arg :id, non_null(:id)
      resolve(&PlanningPokerWeb.Resolvers.Games.find_game/3)
    end

    @desc "Get a round"
    field :round, :round do
      arg :id, non_null(:id)
      resolve(&PlanningPokerWeb.Resolvers.Rounds.find_round/3)
    end

    @desc "Get a user"
    field :user, :user do
      arg :id, non_null(:id)
      resolve(&PlanningPokerWeb.Resolvers.Accounts.find_user/3)
    end

    @desc "Gets the profile for the current user"
    field :current_user, type: :user do
      resolve(&PlanningPokerWeb.Resolvers.Accounts.current_user/3)
    end
  end

  mutation do
    @desc "Changes the amount on an arbitrary estimate"
    field :update_estimate, type: :estimate do
      arg(:id, non_null(:id))
      arg(:amount, :string)
      resolve(&PlanningPokerWeb.Resolvers.Rounds.update_estimate/3)
    end

    @desc "Logs in a user by email"
    field :login, type: :session do
      arg(:email, non_null(:string))
      resolve(&PlanningPokerWeb.Resolvers.Accounts.login_user/3)
    end

    @desc "Creates a new round for the given game, also creates new estimates for all players"
    field :next_round, type: :round do
      arg(:game_id, non_null(:id))
      # For the heck of it I'm using a fn here rather than
      # adding another function to the resolver
      resolve(fn _, %{game_id: game_id}, _ ->
        PlanningPoker.Rounds.next_round(game_id)
      end)
    end

    @desc "Closes the current round without opening a new one"
    field :close_round, type: :round do
      arg(:id, non_null(:id))
      resolve(fn _, %{id: id}, _ ->
        PlanningPoker.Rounds.close_round(id)
      end)
    end
  end
end
