defmodule UnboardQl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Supervisor.Spec

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      UnboardQl.Repo,
      # Start the endpoint when the application starts
      UnboardQlWeb.Endpoint,
      # Starts a worker by calling: UnboardQl.Worker.start_link(arg)
      # {UnboardQl.Worker, arg},
      worker(ConCache, [[name: :giphy_cache, global_ttl: :timer.minutes(15), ttl_check_interval: :timer.seconds(30)]], [id: :giphy_cache]),
      worker(ConCache, [[name: :bbuy_cache, global_ttl: :timer.minutes(30), ttl_check_interval: :timer.seconds(30)]], [id: :bbuy_cache]),
      worker(ConCache, [[name: :txt_cache, global_ttl: :timer.minutes(15), ttl_check_interval: :timer.seconds(30)]], [id: :txt_cache])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UnboardQl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UnboardQlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
