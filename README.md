# Mangax

## Downloaders

Add a module for the manga in manga folder of type given below and implement Manga Protocol

```elixir
@type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          chapter_range: Range.t() | list(),
          page_range: Range.t()
        }

defstruct name: "AttackOnTitans",
            chapter_range: 1..139,
            page_range: 1..75,
            url: "https://s1.cdn-manga.com/files/WP-manga/data/955/CHAPTER/PAGE.jpg"

defprotocol Manga do
  @spec encode_chapter_name(Manga.t(), String.t() | number()) :: String.t()
  def encode_chapter_name(manga, chapter)
end
```

To start downloading, call the function in iex.
> Mangax.__MODULE__.download()

## Reader

Visit [site](localhost:4000) for reading the downloaded manga

## PDF

Visit [site](localhost:4000/manga/chapter) to open in browser to print as PDF.