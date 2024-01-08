defmodule Mangax.OnePunchMan do
  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t(),
          page_range: Range.t()
        }

  defstruct name: "OnePunchMan",
            chapter_range: 150..200,
            page_range: 1..60,
            url:
              "https://cdn.readkakegurui.com/file/cdnpog/one-punch-man/chapter-CHAPTER/PAGE.webp"

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end

  @spec encode_chapter_name(number()) :: String.t()
  def encode_chapter_name(chapter), do: "#{chapter}"
end

defimpl Manga, for: Mangax.OnePunchMan do
  @spec encode_chapter_name(Mangax.OnePunchMan.t(), number()) :: String.t()
  def encode_chapter_name(_manga, chapter), do: Mangax.OnePunchMan.encode_chapter_name(chapter)
end
