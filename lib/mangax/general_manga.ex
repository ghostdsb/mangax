defmodule Mangax.GeneralManga do
  @spec start_downloading(Manga.t()) :: :ok
  def start_downloading(manga) do
    manga.chapter_range
    |> Enum.map(fn chapter_number ->
      %{
        page_url:
          String.replace(manga.url, "CHAPTER", Manga.encode_chapter_name(manga, chapter_number)),
        chapter_name: chapter_number
      }
    end)
    |> Enum.with_index()
    |> Enum.each(fn {chapter_details, index} ->
      DynamicSupervisor.start_child(
        Mangax.DownloadSupervisor,
        {Mangax.Batcher,
         [
           index,
           chapter_details,
           manga.name,
           manga
         ]}
      )
      |> IO.inspect()
    end)
  end
end
