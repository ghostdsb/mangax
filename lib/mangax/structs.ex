defmodule Mangax.ChapterDetails do
  @type t :: %{
          page_url: String.t(),
          chapter_name: String.t()
        }

  defstruct [:page_url, :chapter_name]
end

defmodule Mangax.Image do
  @type t :: %{
          image_link: String.t(),
          image_name: String.t()
        }
  defstruct [:image_link, :image_name]
end

defmodule Mangax.Download do
  @type t :: %{
          chapter_name: String.t(),
          images: list(Mangax.Image.t()),
          manga_name: String.t()
        }
  defstruct [:images, :chapter_name, :manga_name]
end

defmodule Mangax.Manga do
  @type t :: %{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t() | list(number())
        }
  defstruct [:name, :url, :chapter_range]
end
