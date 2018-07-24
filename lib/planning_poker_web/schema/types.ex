defmodule PlanningPokerWeb.Schema.Types do
  import Absinthe.Resolution.Helpers
  alias PlanningPokerWeb.DataSources
  use Absinthe.Schema.Notation

  # enum :estimate_amount do
  #   value :"1"
  #   value :"2"
  #   value :"3"
  #   value :"5"
  #   value :"8"
  #   value :"13"
  #   value :pass
  # end

  object :game do
    field(:id, :id)
    field(:name, :string)
    field(:status, :string)
    # field :rounds, list_of(:round) do
    #   resolve fn game, _, _ ->
    #     rounds = game |> Ecto.assoc(:rounds) |> PlanningPoker.Repo.all
    #     {:ok, rounds}
    #   end
    field(:rounds, list_of(:round), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.Round))
    field :current_round, :round do
      resolve  fn game, _, _ ->
        {:ok, PlanningPoker.Games.current_round(game)}
      end
    end
  end

  object :round do
    field(:id, :id)
    field(:status, :string)
    field(:game, :game)
    field(:estimates, list_of(:estimate), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.Estimate))
  end

  object :estimate do
    field(:id, :id)
    field(:amount, :string)
    field(:user, :user, resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.User))
  end

  object :user do
    field(:id, :id)
    field(:email, :string)
  end

  object :session do
    field(:token, :string)
  end
end
