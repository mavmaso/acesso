defmodule Acesso.Repo do
  use Ecto.Repo,
    otp_app: :acesso,
    adapter: Ecto.Adapters.Postgres
end
