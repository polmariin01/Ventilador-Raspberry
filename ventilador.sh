#!/bin/bash

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to GPIO pin number
# The fan will be assigned in GPIO11 and the GND will be the pin next to it
FAN=11

# Assign names to states
ON="1"
OFF="0"

# Utility function to export a pin if not already exported
exportPin()
{
  if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
    echo "$1" > $BASE_GPIO_PATH/export
  fi
}

# Utility function to set a pin as an output
setOutput()
{
  echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

# Utility function to change the state of the fan
setFanState()
{
  echo $2 > $BASE_GPIO_PATH/gpio$1/value # Posa ON o OFF al gpio del ventilador
}

# Utility function to turn the fan down
setFanOff()
{
  setFanState $FAN $OFF
}

# Ctrl-C handler for clean shutdown
shutdown()
{
  setFanOff
  exit 0
}

trap shutdown SIGINT

# Export pin so that we can use it
exportPin $FAN

# Set pin as output
setOutput $FAN

# Turn the fan down to begin
setFanOff

# Loop forever until user presses Ctrl-C
while [ 1 ]
do
  # Fan ON
  setFanState $FAN $ON
  sleep 30

  # Fan OFF
  setFanState $FAN $OFF
  sleep 30
done
