defmodule PlanningPoker.GamesTest do
  use PlanningPoker.DataCase

  alias PlanningPoker.Factory
  alias PlanningPoker.Games
  alias PlanningPoker.Games.{Game, GamePlayer}
  alias PlanningPoker.Rounds.Estimate

  describe "games" do

    @valid_attrs %{name: "some name", status: "open"}
    @update_attrs %{name: "some updated name", status: "closed"}
    @invalid_attrs %{name: nil, status: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(@valid_attrs)
      assert game.name == "some name"
      assert game.status == "open"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.name == "some updated name"
      assert game.status == "closed"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "players" do

    test "join_game/2 adds the player and an estimate to a game" do
      game = Factory.insert(:game)
      |> Factory.with_round()
      user = Factory.insert(:user)

      Games.join_game(game.id, user)

      assert Repo.get_by(GamePlayer, game_id: game.id, user_id: user.id) != nil
      assert Repo.one(Estimate) != nil
    end

    test "leave_game/2 removes the player and all their estimates from a game" do

    end
  end
end
