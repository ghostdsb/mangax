defprotocol ProtocolManga do
  defstruct [:name, :chapter_range, :page_range, :url]

  @doc """
  Some good manga sites encode their chapter names(by md5, base64 etc). This feature is good to have but
  search for sites that donot encode the chapter name
  """
  @spec encode_chapter_name(Mangax.Manga.t(), String.t() | number()) :: String.t()
  def encode_chapter_name(manga, chapter)
end
