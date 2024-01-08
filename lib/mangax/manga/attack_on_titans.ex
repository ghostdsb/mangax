defmodule Mangax.AttackOnTitans do
  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t(),
          page_range: Range.t()
        }

  defstruct name: "AttackOnTitans",
            chapter_range: 1..139,
            page_range: 1..75,
            url: "https://s1.cdn-manga.com/files/WP-manga/data/955/CHAPTER/PAGE.jpg"

  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end

  def chapter_decode(chapter) do
    :crypto.hash(:md5, "Chapter #{chapter}") |> Base.encode16(case: :lower)
  end
end
