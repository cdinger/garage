defmodule Garage.MQTTHandler do
  use Tortoise.Handler
  require Logger

  def init(args) do
    {:ok, args}
  end

  def handle_message(["home", "garage", "door", "set"], "OPEN", _state) do
    Garage.DoorSwitch.activate()
    Tortoise.publish(Garage, "home/garage/door", "opening", qos: 0)
    {:ok, nil}
  end

  def handle_message(["home", "garage", "door", "set"], "CLOSE", _state) do
    Garage.DoorSwitch.activate()
    Tortoise.publish(Garage, "home/garage/door", "closing", qos: 0)
    {:ok, :closing}
  end

  def handle_message(["home", "garage", "door", "set"], "STOP", _state) do
    Garage.DoorSwitch.activate()
    {:ok, :stopped}
  end

  def handle_message(topic, payload, state) do
    Logger.info("Catch-all #{topic}: #{payload}")
    {:ok, state}
  end

  def connection(_status, state) do
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
