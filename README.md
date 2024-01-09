# Mangax

Once download process starts, it spawns a pool of workers that download pages from 
each chapter asynchronously.

![demonslayer](./assets/demo.png)

## Features

- Download mangas by providing wildcard urls
- Doesn ot download if already downloaded
- Manga reader for easy reading
- Open manga in browser to download as PDF

## How to use
### Downloaders

Add a module for the manga in manga folder of type given below and implement `ProtocolManga`. Check out [a_manga](./lib/mangax/a_manga).

```elixir
defstruct 
  name: "MangaName",
  chapter_range: (1..139 |> Enum.to_list()) ++ [139.5],
  url: "https://www.somemangasite/CHAPTER/PAGE.jpg"
```

To start downloading, call the function in iex.
> Mangax.__MODULE__.download()

### Reader

Visit `localhost:4000` for reading the downloaded manga

### PDF

Visit `localhost:4000/manga/chapter` to open in browser to print as PDF.