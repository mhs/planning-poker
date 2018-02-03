defmodule PlanningPokerWeb.GameController do
  use PlanningPokerWeb, :controller

  alias PlanningPoker.Games
  alias PlanningPoker.Games.{Game, Round}

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Games.change_game(%Game{status: "open"})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    case Games.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def new_round(conn, %{"game_id" => game_id}) do
    case Games.create_round(%{game_id: game_id, status: "open"}) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: game_path(conn, :show, game_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> redirect(to: game_path(conn, :show, game_id))
    end
  end

  def join(conn, %{"game_id" => game_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    case Games.join_game(game_id, current_user) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "You have joined the game")
        |> redirect(to: game_path(conn, :show, game_id))
      {:error, error_msg} ->
        conn
        |> put_flash(:error, error_msg)
        |> redirect(to: game_path(conn, :show, game_id))
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    current_round = Games.current_round(game)
    players = Games.get_players(game)
    render(conn, "show.html", game: game, current_round: current_round, players: players)
  end

  def edit(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    changeset = Games.change_game(game)
    conn
    |> put_flash(:info, "You have joined the game")
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    case Games.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    {:ok, _game} = Games.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end
end
