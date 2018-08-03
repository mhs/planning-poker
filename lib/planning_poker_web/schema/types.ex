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
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:status, non_null(:string))
    field(:rounds, non_null(list_of(:round)), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.Round))
    field :current_round, :round do
      resolve  fn game, _, _ ->
        {:ok, PlanningPoker.Games.current_round(game)}
      end
    end
    field(:players, list_of(:user), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.User))
  end

  object :round do
    field(:id, :id)
    field(:status, non_null(:string))
    field(:game, non_null(:game))
    field(:estimates, list_of(:estimate), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.Estimate))
  end

  object :estimate do
    field(:id, non_null(:id))
    field(:amount, :string)
    field(:user, non_null(:user), resolve: Absinthe.Resolution.Helpers.dataloader(DataSources.User))
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
  end

  object :session do
    field(:token, non_null(:string))
  end
end
