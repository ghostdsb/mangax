defmodule Mangax.Tesla do
  @moduledoc """
  Download image from the url
  """

  @doc """
  Accepts url and return image binary only if its an image
  """
  @spec fetch(url :: String.t()) :: {:ok, binary()} | :error | {:error, :not_an_image}
  def fetch(url) do
    with {:ok, %Tesla.Env{body: body, headers: headers}} <-
           Tesla.get(url, opts: [adapter: [recv_timeout: 60_000]]),
         {_, content_type} <- headers |> List.keyfind("content-type", 0),
         :ok <- is_image(content_type) do
      {:ok, body}
    else
      {:error, :not_an_image} -> {:error, :not_an_image}
      _ -> :error
    end
  end

  defp is_image("image/" <> _type), do: :ok
  defp is_image(_), do: {:error, :not_an_image}
end
