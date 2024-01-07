defmodule Mangax.OnePunchMan do
  def fetch do
    anime_url()
    |> anime_homepage()
    |> chapter_links()
    |> Enum.with_index()
    |> Enum.each(fn {chapter_details, index} ->
      DynamicSupervisor.start_child(
        Mangax.DownloadSupervisor,
        {Mangax.Batcher,
         [
           index,
           chapter_details,
           Mangax.OnePunchMan,
           "OnePunchMan"
         ]}
      )
    end)
  end

  def fetch_chapter_homepage(%{page_url: page_url}) do
    page_url
    |> Mangax.Site.fetch()
    |> Floki.parse_document()
    |> case do
      {:ok, document} -> Floki.find(document, "p")
      _ -> []
    end
  end

  @spec chapter_links(any) ::
          list(%{
            page_url: page_url :: String.t(),
            chapter_name: chapter_name :: String.t()
          })
  def chapter_links(a_tags) do
    a_tags
    |> Enum.filter(fn a_tag -> filter_a_tag(a_tag) end)
    |> Enum.map(fn {"a", [{_href, chapter_page_url}], [chapter_name]} ->
      %{
        page_url: chapter_page_url,
        chapter_name: chapter_name
      }
    end)
  end

  @spec image_links(any) ::
          list(%{
            image_link: image_link :: String.t(),
            image_name: image_name :: String.t()
          })
  def image_links(p_tags) do
    p_tags
    |> Enum.filter(fn p_tag -> filter_p_tag(p_tag) end)
    |> Enum.map(fn {"p", [], [{"img", attr, []}]} ->
      attr = attr -- [{"decoding", "async"}]

      [
        {"src", image_link},
        {"alt", image_name},
        {"title", _image_title}
      ] = attr

      %{
        image_link: image_link,
        image_name: image_name
      }
    end)
  end

  def anime_homepage(url) do
    url
    |> Mangax.Site.fetch()
    |> Floki.parse_document()
    |> case do
      {:ok, document} -> Floki.find(document, "a")
      _ -> []
    end
  end

  defp filter_a_tag({"a", [{tag, chapter_page_url}], [_chapter_name]}) do
    tag == "href" and String.contains?(chapter_page_url, "one-punch-man-chapter")
  end

  defp filter_a_tag({"a", _attr, _children_node}), do: false

  defp filter_p_tag({"p", [], [{"img", [{"decoding", "async"}, _src, _alt, _title], []}]}),
    do: true

  defp filter_p_tag({"p", [], [{"img", [_src, _alt, _title], []}]}), do: true
  defp filter_p_tag({"p", _attr, _children_nodes}), do: false

  defp anime_url, do: "https://w4.1punchman-manga.com"
end
