defmodule UnboardQl.Repo do
  use Ecto.Repo,
    otp_app: :unboard_ql,
    adapter: Ecto.Adapters.Postgres
end
