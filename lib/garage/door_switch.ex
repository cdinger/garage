defmodule Garage.DoorSwitch do
  use GenServer
  require Logger

  @switch_activation_time_in_ms 500
  @switch_pin 4

  def activate do
    GenServer.cast(__MODULE__, :activate)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_state) do
    Logger.info("Door switch init...")
    {:ok, gpio} = Circuits.GPIO.open(@switch_pin, :output)
    {:ok, %{gpio: gpio}}
  end

  def handle_cast(:activate, state = %{gpio: gpio}) do
    Logger.info("Activating door switch...")
    Circuits.GPIO.write(gpio, 1)
    Process.sleep(@switch_activation_time_in_ms)
    Circuits.GPIO.write(gpio, 0)

    {:noreply, state}
  end
end
