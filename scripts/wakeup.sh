#! /bin/bash

# Wakeup a host using WoL and its MAC address, specified
# in hosts.sh

# Needs WAKEUP_INTERFACE in secrets.sh

# some helpers and error handling:
info() {
  [ "$QUIET" = "true" ] || printf "\n%s %s\n" "$( date )" "$*" >&2;
}
trap 'echo $( date ) wakeup interrupted >&2; exit 2' INT TERM

# https://stackoverflow.com/a/14203146
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -w|--wait)
    WAIT="true"
    shift # past argument
    ;;
    -q|--quiet)
    QUIET="true"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z "$1" ]; then
  echo "Missing arg: Host name"
  exit 1
fi

TARGET=$1

SCRIPTS="/opt/scripts"
source "${SCRIPTS}/hosts.sh"
source "${SCRIPTS}/secrets.sh"

mac=${macs[${TARGET}]}

# Try 10 times just in case
for i in {1..10}; do
  sudo etherwake -i "$WAKEUP_INTERFACE" "$mac"
  sleep 0.1
done

if [ "$WAIT" = "true" ]; then
  # Wakeup and wait
  info "Waiting for $TARGET to wake up..."
  $SCRIPTS/wakeup.sh "$TARGET"
  MAX_SECONDS=300
  SECONDS=0
  while [ -z "$($SCRIPTS/checkservers.sh | grep $TARGET | grep ON)" ] && [ $SECONDS -lt $MAX_SECONDS ]; do
    sleep 1
    SECONDS=$((SECONDS+1))
  done
  # Exit if it timed out
  if [ $SECONDS = $MAX_SECONDS ]; then
    info "ERROR: Could not wake up $TARGET. Exiting..."
    exit 1
  elif [ $SECONDS = 0 ]; then
    info "$TARGET was already awake"
  else
    info "$TARGET has woken up!"
  fi
fi
