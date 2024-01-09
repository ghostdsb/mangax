defmodule Mangax.OnePunchMan do
  @type t :: Mangax.Manga.t()

  defstruct name: "OnePunchMan",
            chapter_range: 150..200,
            url:
              "https://cdn.readkakegurui.com/file/cdnpog/one-punch-man/chapter-CHAPTER/PAGE.webp"

  @spec encode_chapter_name(number()) :: String.t()
  def encode_chapter_name(chapter), do: "#{chapter}"

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.Downloader.start()
  end
end

defimpl ProtocolManga, for: Mangax.OnePunchMan do
  @spec encode_chapter_name(Mangax.OnePunchMan.t(), number()) :: String.t()
  def encode_chapter_name(_manga, chapter), do: Mangax.OnePunchMan.encode_chapter_name(chapter)
end
