defmodule UnboardQlWeb.PageController do
  use UnboardQlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
