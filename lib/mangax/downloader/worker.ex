defmodule Mangax.Downloader.Worker do
  @moduledoc """
  Worker module that takes care of calling the downloading process, storing the image and
  also kills itself after batch completion.

  We download an image only if its not already downloaded.

  Also kills self when downloader starts return non-image data; signalling termination of
  manga.
  """
  use GenServer

  @type t :: %{
          progress: number(),
          total: number(),
          retries: number(),
          chapter_name: String.t(),
          images: list(Mangax.Image),
          manga_name: String.t()
        }

  defstruct [:progress, :total, :retries, :images, :chapter_name, :manga_name]

  require Logger

  @spec start_link(list(Mangax.Download.t())) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(
        %Mangax.Download{
          manga_name: manga_name,
          chapter_name: chapter_name
        } = download_struct
      ) do
    Process.flag(:trap_exit, true)

    GenServer.start_link(__MODULE__, download_struct, name: :"chapter#{manga_name}#{chapter_name}")
  end

  def status(manga_name, chapter_name) do
    GenServer.call(:"chapter#{manga_name}#{chapter_name}", "status")
  end

  def init(%Mangax.Download{manga_name: manga_name, chapter_name: chapter_name, images: images}) do
    Logger.info("STARTING DOWNLOADER FOR #{inspect(chapter_name)}")

    File.mkdir_p("#{:code.priv_dir(:mangax)}/static/images/#{manga_name}/#{chapter_name}")

    {:ok,
     %Mangax.Downloader.Worker{
       progress: 0,
       total: Enum.count(images),
       retries: 0,
       chapter_name: chapter_name,
       images: images,
       manga_name: manga_name
     }, {:continue, :start_batch}}
  end

  def handle_continue(:start_batch, %Mangax.Downloader.Worker{images: images} = state) do
    Process.send_after(self(), {"download", images}, 1000)
    {:noreply, state}
  end

  def handle_info({"download", []}, %Mangax.Downloader.Worker{} = state) do
    Logger.info("#{state.chapter_name} DOWNLOAD COMPLETE")

    :"chapter#{state.manga_name}#{state.chapter_name}"
    |> Process.whereis()
    |> kill_process()

    {:noreply, state}
  end

  def handle_info(
        {"download", [image_details | rest] = images},
        %Mangax.Downloader.Worker{} = state
      ) do
    Logger.info("#{state.chapter_name} DOWNLOADING #{inspect(state.progress)}/#{state.total}")

    download(image_details, state.chapter_name, state.manga_name)
    |> case do
      :ok ->
        Process.send_after(self(), {"download", rest}, 1000)
        state = %Mangax.Downloader.Worker{state | progress: state.progress + 1}
        {:noreply, state}

      _ ->
        Process.send_after(self(), {"download", images}, 1000)
        state = %Mangax.Downloader.Worker{state | retries: state.retries + 1}
        {:noreply, state}
    end
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  def handle_call("status", _from, state) do
    {:reply, state, state}
  end

  def terminate(reason, state) do
    IO.inspect(reason, label: :terminating)
    IO.inspect(state, label: :terminating)
  end

  @spec download(Mangax.Image.t(), String.t(), String.t()) :: :ok
  def download(
        %Mangax.Image{image_link: image_link, image_name: image_name},
        chapter_name,
        manga_name
      ) do
    image_path =
      "#{:code.priv_dir(:mangax)}/static/images/#{manga_name}/#{chapter_name}/#{image_name}.jpg"

    with false <- File.exists?(image_path),
         {:ok, iodata} <- Mangax.Tesla.fetch(image_link) do
      File.write(
        "#{:code.priv_dir(:mangax)}/static/images/#{manga_name}/#{chapter_name}/#{image_name}.jpg",
        iodata
      )
    else
      {:error, :not_an_image} ->
        :"chapter#{manga_name}#{chapter_name}"
        |> Process.whereis()
        |> kill_process()

        :ok

      _ ->
        :ok
    end
  end

  defp kill_process(nil), do: :ok

  defp kill_process(pid) do
    DynamicSupervisor.terminate_child(Mangax.DownloadSupervisor, pid)
  end
end
