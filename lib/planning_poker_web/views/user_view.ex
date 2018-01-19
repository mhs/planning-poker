defmodule PlanningPokerWeb.UserView do
  use PlanningPokerWeb, :view
  use JaSerializer.PhoenixView
  attributes [:avatar, :email, :first_name, :last_name, :auth_provider]
end
