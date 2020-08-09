#! /bin/bash

# Wakeup a host using WoL and its MAC address, specified
# in hosts.sh

# Needs WAKEUP_INTERFACE in secrets.sh

if [ -z "$1" ]; then
  echo "Missing arg: Host name"
  exit 1
fi

TARGET=$1

SCRIPTS_DIR="$(realpath "$0" | xargs dirname)"
source "${SCRIPTS_DIR}/hosts.sh"

mac=${hosts[${TARGET}]}

# Try 10 times just in case
for i in {1..10}; do
  sudo etherwake -i "$WAKEUP_INTERFACE" "$mac"
  sleep 0.1
done
