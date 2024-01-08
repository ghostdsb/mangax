defmodule Mangax.AttackOnTitans do
  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t(),
          page_range: Range.t()
        }

  defstruct name: "AttackOnTitans",
            chapter_range: (1..139 |> Enum.to_list()) ++ [139.5],
            page_range: 1..20,
            url: "https://s1.cdn-manga.com/files/WP-manga/data/955/CHAPTER/PAGE.jpg"

  @spec download() :: :ok
  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end

  @spec encode_chapter_name(number()) :: binary()
  def encode_chapter_name(chapter) do
    :crypto.hash(:md5, "Chapter #{chapter}") |> Base.encode16(case: :lower)
  end
end

defimpl Manga, for: Mangax.AttackOnTitans do
  @spec encode_chapter_name(Mangax.AttackOnTitans.t(), number()) :: binary()
  def encode_chapter_name(_manga, chapter) do
    Mangax.AttackOnTitans.encode_chapter_name(chapter)
  end
end
