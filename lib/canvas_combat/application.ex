defmodule CanvasCombat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CanvasCombatWeb.Telemetry,
      # Start the Ecto repository
      CanvasCombat.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CanvasCombat.PubSub},
      # Start Finch
      {Finch, name: CanvasCombat.Finch},
      # Start the Endpoint (http/https)
      CanvasCombatWeb.Endpoint,
      {Registry, keys: :unique, name: CanvasCombat.GameRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: CanvasCombat.GameSupervisor}
      # Start a worker by calling: CanvasCombat.Worker.start_link(arg)
      # {CanvasCombat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CanvasCombat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CanvasCombatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
