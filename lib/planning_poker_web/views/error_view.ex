defmodule PlanningPokerWeb.ErrorView do
  use PlanningPokerWeb, :view
  use JaSerializer.PhoenixView

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("401.json-api", _assigns) do
    %{title: "Unauthorized", code: 401}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("403.json-api", _assigns) do
    %{title: "Forbidden", code: 403}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("404.json-api", _assigns) do
    %{title: "Page not found", code: 404}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("422.json-api", _assigns) do
    %{title: "Unprocessable entity", code: 422}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("500.json-api", _assigns) do
    %{title: "Internal Server Error", code: 500}
    |> JaSerializer.ErrorSerializer.format()
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
