defmodule PlanningPoker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlanningPoker.Accounts.User
  alias Ueberauth.Auth
  alias PlanningPoker.Games.GamePlayer

  schema "users" do
    field(:email, :string)
    field(:auth_provider, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:avatar, :string)

    has_many(:game_players, GamePlayer)
    has_many(:games, through: [:game_players, :game])

    timestamps()
  end

  def basic_info(%Auth{} = auth) do
    {:ok,
     %{
       avatar: auth.info.image,
       email: auth.info.email,
       first_name: auth.info.first_name,
       last_name: auth.info.last_name
     }}
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :auth_provider, :first_name, :last_name, :avatar])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
