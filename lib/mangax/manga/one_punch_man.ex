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

  def download do
    __MODULE__.__struct__()
    |> Mangax.GeneralManga.start_downloading()
  end
end
