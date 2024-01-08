defmodule Mangax.Site do
  @spec fetch(url :: String.t()) :: {:ok, binary()} | :error
  def fetch(url) do
    url |> IO.inspect(label: "URL")

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
