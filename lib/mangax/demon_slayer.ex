defmodule Mangax.DemonSlayer do
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
           Mangax.DemonSlayer,
           "DemonSlayer"
         ]}
      )
    end)
  end

  def fetch_chapter_homepage(%{page_url: page_url}) do
    page_url
    |> Mangax.Site.fetch()
    |> Floki.parse_document()
    |> case do
      {:ok, document} -> Floki.find(document, "img")
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
  def image_links(img_tags) do
    img_tags
    |> Enum.filter(fn img_tag -> filter_img_tag(img_tag) end)
    |> Enum.map(fn {"img", attr, _} ->
      image_link = get_img(attr)
      "https://demonslayer-manga.org/wp-content/uploads/" <> image_file = image_link

      image_name =
        image_file
        |> String.trim(".jpg")
        |> String.replace("/", "-")

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
    tag == "href" and String.contains?(chapter_page_url, "demon-slaye")
  end

  defp filter_a_tag({"a", _attr, _children_node}), do: false

  defp filter_img_tag({"img", attr, _}) do
    attr
    |> Enum.map(fn {tag, _} -> tag end)
    |> Enum.find(fn tag -> tag == "srcset" end)
    |> then(fn tag -> not is_nil(tag) end)
  end

  defp get_img(attrs) do
    attrs
    |> Enum.find(fn {tag, _img_link} -> tag == "src" end)
    |> then(fn {_tag, img_link} -> img_link end)
  end

  defp anime_url, do: "https://demonslayer-manga.org/"
end
