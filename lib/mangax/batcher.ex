defmodule Mangax.Batcher do
  use GenServer

  require Logger

  def start_link([batch, chapter_details, mod, manga_name]) do
    GenServer.start_link(__MODULE__, [chapter_details, batch, mod, manga_name], name: :"#{batch}")
  end

  def init([chapter_details, batch, mod, manga_name]) do
    Logger.info("STARTING BATCHER FOR #{inspect(batch)}")

    %{
      chapter_name: chapter_name,
      page_url: page_url,
    } = chapter_details

    {:ok, %{chapter_name: chapter_name, page_url: page_url, mod: mod, manga_name: manga_name}, {:continue, :start_batch}}
  end

  def handle_continue(:start_batch, %{chapter_name: chapter_name, page_url: _page_url, mod: mod, manga_name: manga_name} = state) do
    images =
      state
      |> mod.fetch_chapter_homepage()
      |> mod.image_links()

    DynamicSupervisor.start_child(
      Mangax.DownloadSupervisor,
      {Mangax.Downloader, [chapter_name, images, manga_name]}
    )

    {:noreply, state}
  end
end
