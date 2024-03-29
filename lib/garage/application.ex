defmodule Garage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Garage.Supervisor]

    children =
      [
        {Garage.DoorSensor, []},
        {Garage.DoorSwitch, []},
        {Garage.ServiceDoorSensor, []},
        {Tortoise.Connection, [
          client_id: Garage,
          handler: {Garage.MQTTHandler, []},
          server: {Tortoise.Transport.SSL, host: Application.get_env(:tortoise, :server), port: Application.get_env(:tortoise, :port), verify: :verify_none},
          user_name: Application.get_env(:tortoise, :user),
          password: Application.get_env(:tortoise, :password),
          subscriptions: ["home/garage/door/set"],
          will: %Tortoise.Package.Publish{topic: "home/garage/status", payload: "offline"}
        ]}
        # Children for all targets
        # Starts a worker by calling: Garage.Worker.start_link(arg)
        # {Garage.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Garage.Worker.start_link(arg)
      # {Garage.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Garage.Worker.start_link(arg)
      # {Garage.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:garage, :target)
  end
end
