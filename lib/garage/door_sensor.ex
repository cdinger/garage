defmodule Garage.DoorSensor do
  use GenServer
  require Logger

  @sensor_pin 26

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
  def init(_) do
    {:ok, gpio} = Circuits.GPIO.open(@sensor_pin, :input, pull_mode: :pullup)
    Circuits.GPIO.set_interrupts(gpio, :both)
    {:ok, %{gpio: gpio}}
  end

  def handle_info({:circuits_gpio, @sensor_pin, _timestamp, value}, state) do
    Logger.info("#{__MODULE__} is #{nice_value(value)}")
    Tortoise.publish(Garage, "home/garage/door", nice_value(value), retain: true, qos: 0)
    {:noreply, state}
  end

  defp nice_value(pin_value) do
    if pin_value == 0 do
      "closed"
    else
      "open"
    end
  end
end
