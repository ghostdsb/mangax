defmodule Mangax.DemonSlayer do
  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t(),
          page_range: Range.t()
        }

  defstruct name: "DemonSlayer",
            chapter_range: 127..205,
            page_range: 1..60,
            url: "https://cdn.demonslayermanga.com/file/mangap/2285/10CHAPTER000/PAGE.jpg"

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end

  @spec encode_chapter_name(number()) :: String.t()
  def encode_chapter_name(chapter), do: "#{chapter}"
end

defimpl Manga, for: Mangax.DemonSlayer do
  @spec encode_chapter_name(Mangax.DemonSlayer.t(), number()) :: String.t()
  def encode_chapter_name(_manga, chapter), do: Mangax.DemonSlayer.encode_chapter_name(chapter)
end
