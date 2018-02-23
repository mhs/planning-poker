defmodule PlanningPokerWeb.RoundControllerTest do
  use PlanningPokerWeb.ConnCase

  alias PlanningPoker.Factory

  @update_attrs %{status: "closed"}
  @invalid_attrs %{status: nil}

  describe "index" do
    @tag :authenticated
    test "lists all rounds", %{conn: conn} do
      conn = get conn, round_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rounds"
    end
  end

  describe "new round" do
    @tag :authenticated
    test "renders form", %{conn: conn} do
      conn = get conn, round_path(conn, :new)
      assert html_response(conn, 200) =~ "New Round"
    end
  end

  describe "edit round" do
    setup [:create_round]

    @tag :authenticated
    test "renders form for editing chosen round", %{conn: conn, round: round} do
      conn = get conn, round_path(conn, :edit, round)
      assert html_response(conn, 200) =~ "Edit Round"
    end
  end

  describe "update round" do
    setup [:create_round]

    @tag :authenticated
    test "redirects when data is valid", %{conn: conn, round: round} do
      conn = put conn, round_path(conn, :update, round), round: @update_attrs
      assert redirected_to(conn) == round_path(conn, :show, round)

      conn = get conn, round_path(conn, :show, round)
      assert html_response(conn, 200) =~ "closed"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, round: round} do
      conn = put conn, round_path(conn, :update, round), round: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Round"
    end
  end

  describe "delete round" do
    setup [:create_round]

    @tag :authenticated
    test "deletes chosen round", %{conn: conn, round: round} do
      conn = delete conn, round_path(conn, :delete, round)
      assert redirected_to(conn) == round_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, round_path(conn, :show, round)
      end
    end
  end

  defp create_round(_) do
    round = Factory.insert(:round)
    {:ok, round: round}
  end
end
