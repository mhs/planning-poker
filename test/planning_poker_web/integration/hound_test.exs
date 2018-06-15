defmodule HoundTest do
  use ExUnit.Case
  use Hound.Helpers

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PlanningPoker.Repo)
    parent = self()
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(PlanningPoker.Repo, parent)
    Hound.start_session(metadata: metadata)
    on_exit(fn -> Hound.end_session(parent) end)
    :ok
  end

  test "the truth", meta do

    PlanningPoker.Accounts.create_user(%{email: "test@example.com"})
    navigate_to("http://localhost:4001")

    element = find_element(:name, "email")
    fill_field(element, "test@example.com")
    submit_element(element)

    assert String.match?(visible_page_text(), ~r/Welcome back/)

    find_element(:link_text, "Start a game")
    |> click()
  end
end
