defmodule PlanningPoker.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias PlanningPoker.Repo

  alias PlanningPoker.Games.Game
  alias PlanningPoker.Accounts.User

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

  alias PlanningPoker.Games.Round

  def current_round(game) do
    query = from r in Ecto.assoc(game, :rounds),
      where: r.status == "open",
      order_by: r.inserted_at
    Repo.one(query)
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
    IO.puts "creating round with attrs"
    IO.inspect attrs
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

  alias PlanningPoker.Games.Estimate

  @doc """
  Returns the list of estimates.

  ## Examples

      iex> list_estimates()
      [%Estimate{}, ...]

  """
  def list_estimates do
    Repo.all(Estimate)
  end

  @doc """
  Gets a single estimate.

  Raises `Ecto.NoResultsError` if the Estimate does not exist.

  ## Examples

      iex> get_estimate!(123)
      %Estimate{}

      iex> get_estimate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_estimate!(id), do: Repo.get!(Estimate, id)

  @doc """
  Creates a estimate.

  ## Examples

      iex> create_estimate(%{field: value})
      {:ok, %Estimate{}}

      iex> create_estimate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_estimate(attrs \\ %{}) do
    %Estimate{}
    |> Estimate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a estimate.

  ## Examples

      iex> update_estimate(estimate, %{field: new_value})
      {:ok, %Estimate{}}

      iex> update_estimate(estimate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_estimate(%Estimate{} = estimate, attrs) do
    estimate
    |> Estimate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Estimate.

  ## Examples

      iex> delete_estimate(estimate)
      {:ok, %Estimate{}}

      iex> delete_estimate(estimate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_estimate(%Estimate{} = estimate) do
    Repo.delete(estimate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking estimate changes.

  ## Examples

      iex> change_estimate(estimate)
      %Ecto.Changeset{source: %Estimate{}}

  """
  def change_estimate(%Estimate{} = estimate) do
    Estimate.changeset(estimate, %{})
  end

  alias PlanningPoker.Games.GamePlayer

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%GamePlayer{}, ...]

  """
  def list_players do
    Repo.all(GamePlayer)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the GamePlayer does not exist.

  ## Examples

      iex> get_player!(123)
      %GamePlayer{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(GamePlayer, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %GamePlayer{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %GamePlayer{}
    |> GamePlayer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %GamePlayer{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%GamePlayer{} = player, attrs) do
    player
    |> GamePlayer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GamePlayer.

  ## Examples

      iex> delete_player(player)
      {:ok, %GamePlayer{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%GamePlayer{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{source: %GamePlayer{}}

  """
  def change_player(%GamePlayer{} = player) do
    GamePlayer.changeset(player, %{})
  end

  def get_players(%Game{} = game) do
    game
    |> Ecto.assoc(:players)
    |> Repo.all
  end
  def get_players(id), do: get_players(Repo.get!(Game, id))

  def join_game(game_id, user) do
    GamePlayer.changeset(%GamePlayer{}, %{game_id: game_id, user_id: user.id})
    |> Repo.insert
  end
end
