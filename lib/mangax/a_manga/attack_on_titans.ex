defmodule Mangax.AttackOnTitans do
  @type t :: Mangax.Manga.t()

  defstruct name: "AttackOnTitans",
            chapter_range: (1..139 |> Enum.to_list()) ++ [139.5],
            url: "https://s1.cdn-manga.com/files/WP-manga/data/955/CHAPTER/PAGE.jpg"

  @spec encode_chapter_name(number()) :: binary()
  def encode_chapter_name(chapter) do
    :crypto.hash(:md5, "Chapter #{chapter}") |> Base.encode16(case: :lower)
  end

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.Downloader.start()
  end
end

defimpl ProtocolManga, for: Mangax.AttackOnTitans do
  @spec encode_chapter_name(Mangax.AttackOnTitans.t(), number()) :: binary()
  def encode_chapter_name(_manga, chapter) do
    Mangax.AttackOnTitans.encode_chapter_name(chapter)
  end
end
