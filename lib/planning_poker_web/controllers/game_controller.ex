defmodule PlanningPokerWeb.GameController do
  use PlanningPokerWeb, :controller

  alias PlanningPoker.Games
  alias PlanningPoker.Rounds
  alias PlanningPoker.Games.{Game}

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Games.change_game(%Game{status: "open"})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    case Games.create_game_with_round(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :show, game))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def new_round(conn, %{"game_id" => game_id}) do
    case Rounds.next_round(game_id) do
      {:ok, _round} ->
        refresh_game_page(game_id)

        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: game_path(conn, :show, game_id))

      {:error, %Ecto.Changeset{}} ->
        conn
        |> redirect(to: game_path(conn, :show, game_id))
    end
  end

  def close_round(conn, %{"game_id" => game_id}) do
    round = Games.current_round(Games.get_game!(game_id))

    case Rounds.close_round(round) do
      {:ok, _round} ->
        refresh_game_page(game_id)

        conn
        |> put_flash(:info, "Round closed!")
        |> redirect(to: game_path(conn, :show, game_id))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "There was a problem closing the round")
        |> redirect(to: game_path(conn, :show, game_id))
    end
  end

  def join(conn, %{"game_id" => game_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    case Games.join_game(game_id, current_user) do
      {:ok, _player} ->
        refresh_game_page(game_id)

        conn
        |> put_flash(:info, "You have joined the game")
        |> redirect(to: game_path(conn, :show, game_id))

      {:error, error_msg} ->
        conn
        |> put_flash(:error, error_msg)
        |> redirect(to: game_path(conn, :show, game_id))
    end
  end

  defp refresh_game_page(game_id) do
    game = Games.get_game!(game_id)
    current_round = Games.current_round(game)
    players = Games.get_players(game)

    refresh_estimates(game_id, current_round, players)
  end

  defp refresh_estimates(game_id, round, _players) do
    Task.async(fn ->
      new_info =
        Phoenix.View.render_to_string(PlanningPokerWeb.GameView, "estimates.html", %{
          estimates: Rounds.estimates(round),
          round: round
        })

      payload = %{estimates: new_info, roundId: round.id}
      PlanningPokerWeb.Endpoint.broadcast!("game:" <> game_id, "estimates_updated", payload)
    end)
  end

  def leave(conn, %{"game_id" => game_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    case Games.leave_game(game_id, current_user) do
      {:ok, _player} ->
        refresh_game_page(game_id)

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
    current_user = Guardian.Plug.current_resource(conn)

    my_estimate =
      case Rounds.current_estimate(current_round, current_user) do
        nil -> nil
        e -> Ecto.Changeset.change(e)
      end

    render(
      conn,
      "show.html",
      game: game,
      current_round: current_round,
      players: players,
      current_user: current_user,
      estimates: Rounds.estimates(current_round),
      my_estimate: my_estimate
    )
  end

  def estimate(conn, %{
        "game_id" => game_id,
        "estimate" => %{"amount" => amount, "round_id" => round_id}
      }) do
    current_user = Guardian.Plug.current_resource(conn)
    round = Rounds.get_round!(round_id)
    game = Games.get_game!(game_id)
    _players = Games.get_players(game)

    case Rounds.set_estimate(round, current_user, amount) do
      {:ok, _estimate} ->
        refresh_game_page(game_id)

        conn
        |> redirect(to: game_path(conn, :show, game_id))

      {:error, _} ->
        conn
        |> redirect(to: game_path(conn, :show, game_id))
    end
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
