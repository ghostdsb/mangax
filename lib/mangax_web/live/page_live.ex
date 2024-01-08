defmodule MangaxWeb.PageLive do
  @moduledoc false
  use MangaxWeb, :live_view
  use Phoenix.HTML

  @manga "DemonSlayer"
  @chapter "156"

  @impl true
  def mount(_params, _session, socket) do
    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{@manga}/#{@chapter}"
      |> File.ls!()
      |> Enum.count()

    mangas =
      "#{:code.priv_dir(:mangax)}/static/images/"
      |> File.ls!()

    chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{@manga}/"
      |> File.ls!()
      |> Enum.sort()

    socket =
      socket
      |> assign(:mangas, mangas)
      |> assign(:chapters, chapters)
      |> assign(:manga, @manga)
      |> assign(:chapter, @chapter)
      |> assign(:page_count, page_count)

    {:ok, socket}
  end

  @impl true
  def handle_event("next", _params, socket) do
    chapter = socket.assigns.chapter |> String.to_integer()

    socket =
      socket
      |> assign(:chapter, (chapter + 1) |> to_string)

    {:noreply, socket}
  end

  @impl true
  def handle_event("prev", _params, socket) do
    chapter = socket.assigns.chapter |> String.to_integer()

    socket =
      socket
      |> assign(:chapter, (chapter - 1) |> to_string)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", params, socket) do
    %{"manga" => manga, "chapter" => chapter} = params |> IO.inspect()

    chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{@manga}/"
      |> File.ls!()
      |> Enum.sort()

    socket =
      socket
      |> assign(:chapters, chapters)
      |> assign(:manga, manga)
      |> assign(:chapter, chapter)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"manga" => manga} = _value, socket) do
    chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga}/"
      |> File.ls!()
      |> Enum.sort()

    socket =
      socket
      |> assign(:chapters, chapters)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _value, socket) do
    {:noreply, socket}
  end
end
