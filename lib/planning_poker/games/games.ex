defmodule PlanningPoker.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias PlanningPoker.Repo

  alias PlanningPoker.Accounts.User
  alias PlanningPoker.Games.{Game, GamePlayer}
  alias PlanningPoker.Rounds
  alias PlanningPoker.Rounds.Round

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)
  def get_game(id), do: Repo.get(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  def create_game_with_round(attrs \\ %{}) do
    with {:ok, game} <-
           %Game{}
           |> Game.changeset(attrs)
           |> Repo.insert(),
         {:ok, round} <- Rounds.next_round(game.id),
         do: {:ok, game}
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  def current_round(game) do
    from(
      r in Ecto.assoc(game, :rounds),
      order_by: [desc: r.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Returns the list of rounds.

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id), do: Repo.get!(Round, id)

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round(attrs \\ %{}) do
    IO.puts("creating round with attrs")
    IO.inspect(attrs)

    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{source: %Round{}}

  """
  def change_round(%Round{} = round) do
    Round.changeset(round, %{})
  end

  @spec get_players(%Game{}) :: [%PlanningPoker.Accounts.User{}]
  def get_players(%Game{} = game) do
    game
    |> Ecto.assoc(:players)
    |> Repo.all()
  end

  def get_players(id), do: get_players(Repo.get!(Game, id))

  def join_game(game_id, %User{} = user) do
    Repo.transaction(fn ->
      {:ok, game_player} =
        GamePlayer.changeset(%GamePlayer{}, %{game_id: game_id, user_id: user.id})
        |> Repo.insert()

      round = game_id |> get_game!() |> current_round()
      Rounds.create_pending_estimate(round, game_player)
    end)
  end

  def leave_game(game_id, user) do
    Repo.transaction(fn ->
      from(g in GamePlayer, where: [game_id: ^game_id, user_id: ^user.id])
      |> Repo.delete_all()

      # find estimates for all rounds for the user/game
    end)
  end
end
