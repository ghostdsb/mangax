defmodule MangaxWeb.PageLive do
  @moduledoc false
  use MangaxWeb, :live_view
  use Phoenix.HTML

  @manga "DemonSlayer"
  @chapter "132"

  @impl true
  def mount(params, _session, socket) do
    params |> IO.inspect()

    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{@manga}/#{@chapter}"
      |> IO.inspect()
      |> File.ls!()
      |> Enum.count()

    socket =
      socket
      |> assign(:manga, @manga)
      |> assign(:chapter, @chapter)
      |> assign(:page_count, page_count)
    {:ok, socket}
  end

end
