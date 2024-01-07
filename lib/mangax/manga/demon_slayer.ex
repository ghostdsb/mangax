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

  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end
end
