defmodule Mangax.GeneralManga do
  def start_downloading(manga) do
    manga.chapter_range
    |> Enum.map(fn chapter_number ->
      manga_module = manga.__struct__
      %{
        page_url:
          String.replace(manga.url, "CHAPTER", manga_module.chapter_decode(chapter_number)),
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
    end)
  end
end
