defmodule MangaxWeb.PageController do
  use MangaxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
