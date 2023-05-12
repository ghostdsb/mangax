defmodule Mangax.Site do
  @spec fetch(url :: String.t()) :: String.t()
  def fetch(url) do
    Tesla.get(url)
    |> case do
      {:ok, %Tesla.Env{body: body}} -> body
      {:error, _} -> ""
    end
  end
end
