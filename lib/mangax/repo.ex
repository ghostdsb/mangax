defmodule Mangax.Repo do
  use Ecto.Repo,
    otp_app: :mangax,
    adapter: Ecto.Adapters.Postgres
end
