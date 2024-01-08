defmodule Mangax.Batcher do
  use GenServer

  require Logger

  def start_link([batch, chapter_details, manga_name, manga_details]) do
    GenServer.start_link(__MODULE__, [chapter_details, batch, manga_name, manga_details],
      name: :"batch#{manga_name}#{batch}"
    )
  end

  def init([chapter_details, batch, manga_name, manga_details]) do
    Logger.info("STARTING BATCHER FOR #{inspect(batch)}")

    %{
      chapter_name: chapter_name,
      page_url: page_url
    } = chapter_details

    {:ok,
     %{
       chapter_name: chapter_name,
       page_url: page_url,
       manga_name: manga_name,
       manga_details: manga_details
     }, {:continue, :start_batch}}
  end

  def handle_continue(
        :start_batch,
        %{
          chapter_name: chapter_name,
          page_url: page_url,
          manga_name: manga_name,
          manga_details: manga_details
        } = state
      ) do
    images =
      manga_details.page_range
      |> Enum.map(fn image_index ->
        %{
          image_link: String.replace(page_url, "PAGE", image_index |> to_string),
          image_name: "#{image_index}"
        }
      end)

    DynamicSupervisor.start_child(
      Mangax.DownloadSupervisor,
      {Mangax.Downloader, [chapter_name, images, manga_name]}
    )

    {:noreply, state}
  end
end
