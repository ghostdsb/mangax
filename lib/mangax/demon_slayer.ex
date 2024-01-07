defmodule Mangax.DemonSlayer do
  def fetch do
    chapters()
    |> Enum.with_index()
    |> Enum.each(fn {chapter_details, index} ->
      DynamicSupervisor.start_child(
        Mangax.DownloadSupervisor,
        {Mangax.Batcher,
         [
           index,
           chapter_details,
           Mangax.DemonSlayer,
           "DemonSlayer"
         ]}
      )
    end)
  end

  def fetch_chapter_homepage(chapter_details) do
    chapter_details
  end

  def image_links(%{page_url: page_url} = _chapter_details) do
    1..60
    |> Enum.map(fn image_index ->
      %{
        image_link: "#{page_url}#{image_index}.jpg",
        image_name: "#{image_index}"
      }
    end)
  end

  defp anime_url(chapter),
    do: "https://cdn.demonslayermanga.com/file/mangap/2285/10#{chapter}000/"

  defp chapters do
    127..205
    |> Enum.map(fn chapter_number ->
      url = anime_url(chapter_number)

      %{
        page_url: url,
        chapter_name: chapter_number
      }
    end)
  end
end
