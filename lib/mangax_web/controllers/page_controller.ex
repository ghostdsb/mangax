defmodule MangaxWeb.PageController do
  use MangaxWeb, :controller

  def index(conn, %{"manga" => manga, "chapter" => chapter} = _params) do
    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga}/#{chapter}"
      |> IO.inspect()
      |> File.ls!()
      |> Enum.count()
    render(conn, "index.html", manga: manga, chapter: chapter, page_count: page_count)
  end
end
