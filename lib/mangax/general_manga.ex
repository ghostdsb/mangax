defmodule Mangax.GeneralManga do
  def start_downloading(manga_details) do
    manga_details.chapter_range
    |> Enum.map(fn chapter_number ->
      %{
        page_url: String.replace(manga_details.url, "CHAPTER", chapter_number |> to_string),
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
           manga_details.name,
           manga_details
         ]}
      )
    end)
  end
end
