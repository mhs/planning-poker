defmodule PlanningPokerWeb.RoundController do
  use PlanningPokerWeb, :controller

  alias PlanningPoker.Games
  alias PlanningPoker.Rounds.Round

  def index(conn, _params) do
    rounds = Games.list_rounds()
    render(conn, "index.html", rounds: rounds)
  end

  def new(conn, _params) do
    changeset = Games.change_round(%Round{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    round = Games.get_round!(id)
    render(conn, "show.html", round: round)
  end

  def edit(conn, %{"id" => id}) do
    round = Games.get_round!(id)
    changeset = Games.change_round(round)
    render(conn, "edit.html", round: round, changeset: changeset)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Games.get_round!(id)

    case Games.update_round(round, round_params) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round updated successfully.")
        |> redirect(to: round_path(conn, :show, round))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", round: round, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Games.get_round!(id)
    {:ok, _round} = Games.delete_round(round)

    conn
    |> put_flash(:info, "Round deleted successfully.")
    |> redirect(to: round_path(conn, :index))
  end
end
