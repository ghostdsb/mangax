# Mangax

A manga downloader and reader that you can serve and share with your friends.

![demonslayer](./assets/mangax.gif)

## Features

- Download mangas by providing wildcard urls
- Doesn ot download if already downloaded
- Manga reader for easy reading
- Open manga in browser to download as PDF

## How to use

### Run server

> iex -S mix phx.server

### Downloaders

Add a module for the manga in manga folder of type given below and implement `ProtocolManga`. Check out [a_manga](./lib/mangax/a_manga).

```elixir
defstruct 
  name: "MangaName",
  chapter_range: 1..139,
  url: "https://www.somemangasite/CHAPTER/PAGE.jpg"
```

To start downloading, call the function in iex.
> Mangax.__MODULE__.download()

### Reader

Visit `localhost:4000` for reading the downloaded manga

### PDF

Visit `localhost:4000/manga/chapter` to open in browser to print as PDF.