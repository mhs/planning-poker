defmodule PlanningPoker.GamesTest do
  use PlanningPoker.DataCase

  alias PlanningPoker.Games

  describe "games" do
    alias PlanningPoker.Games.Game

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

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
      assert game.status == "some status"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.status == "some updated status"
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

  describe "games" do
    alias PlanningPoker.Games.Game

    @valid_attrs %{name: "some name", status: "some status"}
    @update_attrs %{name: "some updated name", status: "some updated status"}
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
      assert game.status == "some status"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.name == "some updated name"
      assert game.status == "some updated status"
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

  describe "rounds" do
    alias PlanningPoker.Games.Round

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def round_fixture(attrs \\ %{}) do
      {:ok, round} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_round()

      round
    end

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Games.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Games.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      assert {:ok, %Round{} = round} = Games.create_round(@valid_attrs)
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      assert {:ok, round} = Games.update_round(round, @update_attrs)
      assert %Round{} = round
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_round(round, @invalid_attrs)
      assert round == Games.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Games.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Games.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Games.change_round(round)
    end
  end

  describe "rounds" do
    alias PlanningPoker.Games.Round

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def round_fixture(attrs \\ %{}) do
      {:ok, round} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_round()

      round
    end

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Games.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Games.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      assert {:ok, %Round{} = round} = Games.create_round(@valid_attrs)
      assert round.status == "some status"
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      assert {:ok, round} = Games.update_round(round, @update_attrs)
      assert %Round{} = round
      assert round.status == "some updated status"
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_round(round, @invalid_attrs)
      assert round == Games.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Games.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Games.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Games.change_round(round)
    end
  end

  describe "estimates" do
    alias PlanningPoker.Games.Estimate

    @valid_attrs %{amount: "some amount"}
    @update_attrs %{amount: "some updated amount"}
    @invalid_attrs %{amount: nil}

    def estimate_fixture(attrs \\ %{}) do
      {:ok, estimate} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_estimate()

      estimate
    end

    test "list_estimates/0 returns all estimates" do
      estimate = estimate_fixture()
      assert Games.list_estimates() == [estimate]
    end

    test "get_estimate!/1 returns the estimate with given id" do
      estimate = estimate_fixture()
      assert Games.get_estimate!(estimate.id) == estimate
    end

    test "create_estimate/1 with valid data creates a estimate" do
      assert {:ok, %Estimate{} = estimate} = Games.create_estimate(@valid_attrs)
      assert estimate.amount == "some amount"
    end

    test "create_estimate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_estimate(@invalid_attrs)
    end

    test "update_estimate/2 with valid data updates the estimate" do
      estimate = estimate_fixture()
      assert {:ok, estimate} = Games.update_estimate(estimate, @update_attrs)
      assert %Estimate{} = estimate
      assert estimate.amount == "some updated amount"
    end

    test "update_estimate/2 with invalid data returns error changeset" do
      estimate = estimate_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_estimate(estimate, @invalid_attrs)
      assert estimate == Games.get_estimate!(estimate.id)
    end

    test "delete_estimate/1 deletes the estimate" do
      estimate = estimate_fixture()
      assert {:ok, %Estimate{}} = Games.delete_estimate(estimate)
      assert_raise Ecto.NoResultsError, fn -> Games.get_estimate!(estimate.id) end
    end

    test "change_estimate/1 returns a estimate changeset" do
      estimate = estimate_fixture()
      assert %Ecto.Changeset{} = Games.change_estimate(estimate)
    end
  end

  describe "players" do
    alias PlanningPoker.Games.Player

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Games.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Games.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Games.create_player(@valid_attrs)
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Games.update_player(player, @update_attrs)
      assert %Player{} = player
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_player(player, @invalid_attrs)
      assert player == Games.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Games.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Games.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Games.change_player(player)
    end
  end
end
