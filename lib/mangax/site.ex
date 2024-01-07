defmodule Mangax.Site do

  @spec fetch(url :: String.t()) :: String.t()
  def fetch(url) do
    Tesla.get(url, opts: [adapter: [recv_timeout: 60_000]])
    |> case do
      {:ok, %Tesla.Env{body: body}} ->
        {:ok, body}

      {:error, reason} ->
        IO.inspect("#{reason}")
        :error
    end
  end
end
