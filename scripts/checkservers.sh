#! /bin/bash

# Outputs status (ON|OFF) of each host

# Needs hosts associative array to be
# specified in hosts.sh

color=false
[ -n "$1" ] && [ "$1" == "--color" ] && color=true

SCRIPTS_DIR=$(realpath "$0" | xargs dirname)

HOSTS_FILE="${SCRIPTS_DIR}/hosts.sh"
source "$HOSTS_FILE"

if $color; then
	source "${SCRIPTS_DIR}/colors.sh"
fi

lines=""

for host in ${!hosts[@]}; do
  ip=${hosts[${host}]}
  if fping -a -q -t 10 -r 1 -i 1 "$ip" &> /dev/null; then
    status="${Green}ON${Color_Off}"
  else
    status="${Red}OFF${Color_Off}"
  fi
  lines="$lines\n${host} ${status}"
done

echo -e "$lines" | column -t
