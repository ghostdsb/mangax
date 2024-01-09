defmodule Mangax.DemonSlayer do
  @type t :: Mangax.Manga.t()

  defstruct name: "DemonSlayer",
            chapter_range: 127..205,
            url: "https://cdn.demonslayermanga.com/file/mangap/2285/10CHAPTER000/PAGE.jpg"

  @spec encode_chapter_name(number()) :: String.t()
  def encode_chapter_name(chapter), do: "#{chapter}"

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.Downloader.start()
  end
end

defimpl ProtocolManga, for: Mangax.DemonSlayer do
  @spec encode_chapter_name(Mangax.DemonSlayer.t(), number()) :: String.t()
  def encode_chapter_name(_manga, chapter), do: Mangax.DemonSlayer.encode_chapter_name(chapter)
end
