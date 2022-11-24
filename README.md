# Garage

This is an Elixir/Nerves firmware that runs in my garage. It
opens and closes my garage door and senses the state of the garage door and service
door. Commands and states all go through an MQTT server and I consume them from [Home
Assistant](https://www.home-assistant.io/) and HomeKit.

This replaces a hodgepodge of C code and homebridge installations and provides me with
a playground for experimenting with Elixir and Nerves. I'm making this public because
I was surprised by how few example projects I could find that use MQTT and Nerves like this.
Please don't mistake this for good or idiomatic Elixir code :-)

## Hardware

I run this on a Raspberry Pi Zero W. The door sensors are normally-open (NO) magnetic
reed switches and the garage door actuator is a 5V relay module. 

## Deploy to target device

- Fetch dependencies: `MIX_TARGET=rpi0 mix deps.get`
- Compile: `MIX_TARGET=rpi0 mix firmware`
- Write to SD card: `mix burn`

Nerves can also perform over-the-air updates on already deployed devices: `mix upload <IP_ADDRESS>`.

## Targets

Nerves supports other targets. See the their [list of supported devices](https://hexdocs.pm/nerves/targets.html#content). Any of these should work.
