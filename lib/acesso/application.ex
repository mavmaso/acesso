defmodule Acesso.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AcessoWeb.Telemetry,
      Acesso.Repo,
      {DNSCluster, query: Application.get_env(:acesso, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Acesso.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Acesso.Finch},
      # Start a worker by calling: Acesso.Worker.start_link(arg)
      # {Acesso.Worker, arg},
      # Start to serve requests, typically the last entry
      AcessoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acesso.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AcessoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
