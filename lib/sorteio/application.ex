defmodule Sorteio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Sorteio.Draw,
      # Start the Telemetry supervisor
      SorteioWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sorteio.PubSub},
      # Start the Endpoint (http/https)
      SorteioWeb.Endpoint
      # Start a worker by calling: Sorteio.Worker.start_link(arg)
      # {Sorteio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sorteio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SorteioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
