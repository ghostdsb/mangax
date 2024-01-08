defprotocol Manga do
  @spec encode_chapter_name(Manga.t(), String.t() | number()) :: String.t()
  def encode_chapter_name(manga, chapter)
end
