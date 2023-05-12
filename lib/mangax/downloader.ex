defmodule Mangax.Downloader do
  use GenServer

  require Logger

  def start_link([name, images, manga_name]) do
    GenServer.start_link(__MODULE__, [images, name, manga_name], name: :"#{name}")
  end

  def status(name) do
    GenServer.call(:"#{name}", "status")
  end

  def init([images, name, manga_name] = opts) do
    opts |> IO.inspect(label: "DWL OPTS")
    Logger.info("STARTING DOWNLOADER FOR #{inspect(name)}")
    File.mkdir("#{manga_name}/#{name}/")
    {:ok, %{progress: 0, total: Enum.count(images), retries: 0, name: name, images: images, manga_name: manga_name},
     {:continue, :start_batch}}
  end

  def handle_continue(:start_batch, %{images: images} = state) do
    Process.send_after(self(), {"download", images}, 1000)
    {:noreply, state}
  end

  def handle_info({"download", []}, state) do
    Logger.info("#{state.name} DOWNLOAD COMPLETE")
    {:noreply, state}
  end

  def handle_info({"download", [image_details | rest] = images}, state) do
    Logger.info("#{state.name} DOWNLOADING #{inspect(state.progress)}/#{state.total}")

    download(image_details, state.name, state.manga_name)
    |> case do
      :ok ->
        Process.send_after(self(), {"download", rest}, 1000)
        state = %{state | progress: state.progress + 1}
        {:noreply, state}

      _ ->
        Process.send_after(self(), {"download", images}, 1000)
        state = %{state | retries: state.retries + 1}
        {:noreply, state}
    end
  end

  def handle_call("status", _from, state) do
    {:reply, state, state}
  end

  def download(%{image_link: image_link, image_name: image_name} = _image_details, chapter_name, manga_name) do
    body = Mangax.Site.fetch(image_link)
    File.write("#{manga_name}/#{chapter_name}/#{image_name}.jpg", body)
  end
end
