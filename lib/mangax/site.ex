defmodule Mangax.Site do
  @spec fetch(url :: String.t()) :: {:ok, binary()} | :error
  def fetch(url) do
    url |> IO.inspect(label: "URL")

    with {:ok, %Tesla.Env{body: body, headers: headers}} <-
           Tesla.get(url, opts: [adapter: [recv_timeout: 60_000]]),
         {_, content_type} <- headers |> List.keyfind("content-type", 0),
         :ok <- is_image(content_type) do
      {:ok, body}
    else
      _ -> :error
    end
  end

  defp is_image("image/" <> _type), do: :ok
  defp is_image(_), do: :error
end
