defmodule Mangax.Downloader do
  @moduledoc """
  Fetched data from a manga module and divides them in batches and
  starts a worker genserver for each batch under the DownloaderSupervisor.
  """

  @spec start(Mangax.Manga.t()) :: :ok
  def start(manga) do
    manga.chapter_range
    |> Enum.map(fn chapter_number ->
      %Mangax.ChapterDetails{
        page_url:
          String.replace(
            manga.url,
            "CHAPTER",
            ProtocolManga.encode_chapter_name(manga, chapter_number)
          ),
        chapter_name: chapter_number
      }
    end)
    |> Enum.each(fn %Mangax.ChapterDetails{} = chapter_details ->
      images =
        1..200
        |> Enum.map(fn image_index ->
          %Mangax.Image{
            image_link:
              String.replace(chapter_details.page_url, "PAGE", image_index |> to_string),
            image_name: "#{image_index}"
          }
        end)

      downloader_details = %Mangax.Download{
        chapter_name: chapter_details.chapter_name,
        manga_name: manga.name,
        images: images
      }

      DynamicSupervisor.start_child(
        Mangax.DownloadSupervisor,
        {Mangax.Downloader.Worker, downloader_details}
      )
    end)
  end
end
