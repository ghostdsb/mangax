defmodule MangaxWeb.PageLive do
  @moduledoc false
  use MangaxWeb, :live_view
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    [top_manga | _mangas] =
      mangas =
      "#{:code.priv_dir(:mangax)}/static/images/"
      |> File.ls!()

    [top_chapter | _chapters] =
      chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{top_manga}/"
      |> File.ls!()
      |> file_sort

    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{top_manga}/#{top_chapter}"
      |> File.ls!()
      |> Enum.count()

    socket =
      socket
      |> assign(:mangas, mangas)
      |> assign(:chapters, chapters)
      |> assign(:manga, top_manga)
      |> assign(:chapter, top_chapter)
      |> assign(:page_count, page_count)

    {:ok, socket}
  end

  @impl true
  def handle_event("next", _params, socket) do
    next_chapter =
      "#{:code.priv_dir(:mangax)}/static/images/#{socket.assigns.manga}/"
      |> File.ls!()
      |> next_chapter(socket.assigns.chapter)

    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{socket.assigns.manga}/#{next_chapter}"
      |> File.ls!()
      |> Enum.count()

    socket =
      socket
      |> assign(:chapter, next_chapter)
      |> assign(:page_count, page_count)

    {:noreply, socket}
  end

  @impl true
  def handle_event("prev", _params, socket) do
    prev_chapter =
      "#{:code.priv_dir(:mangax)}/static/images/#{socket.assigns.manga}/"
      |> File.ls!()
      |> previous_chapter(socket.assigns.chapter)

    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{socket.assigns.manga}/#{prev_chapter}"
      |> File.ls!()
      |> Enum.count()

    socket =
      socket
      |> assign(:chapter, prev_chapter)
      |> assign(:page_count, page_count)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", params, socket) do
    %{"manga" => manga, "chapter" => chapter} = params |> IO.inspect()

    chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga}/"
      |> File.ls!()
      |> file_sort

    page_count =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga}/#{chapter}"
      |> File.ls!()
      |> Enum.count()

    socket =
      socket
      |> assign(:chapters, chapters)
      |> assign(:manga, manga)
      |> assign(:chapter, chapter)
      |> assign(:page_count, page_count)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"manga" => manga} = _value, socket) do
    chapters =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga}/"
      |> File.ls!()
      |> file_sort

    socket =
      socket
      |> assign(:chapters, chapters)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _value, socket) do
    {:noreply, socket}
  end

  defp file_sort(chapter_list) do
    chapter_list
    |> Enum.map(fn chapter -> {chapter, Integer.parse(chapter)} end)
    |> Enum.filter(fn {_chapter, val} -> val != :error end)
    |> Enum.sort_by(fn {_chapter_name, {chapter, _}} -> chapter end, :asc)
    |> Enum.map(fn {chapter, {_chapter, _}} -> chapter end)
  end

  def next_chapter(chapters, current_chapter) do
    [_current, next] =
      chapters
      |> file_sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.find([current_chapter, current_chapter], fn [a, _b] ->
        a == current_chapter
      end)

    next
  end

  def previous_chapter(chapters, current_chapter) do
    [prev, _current] =
      chapters
      |> file_sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.find([current_chapter, current_chapter], fn [_a, b] ->
        b == current_chapter
      end)

    prev
  end
end
