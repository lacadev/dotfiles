#! /bin/bash

# Update home ip in a bitwarden safe note called "home-ip"
# I recommend using a separate account for this,
# sharing the note with your personal one if needed

# Needs BW_SESSION in secrets.sh
SCRIPTS_DIR="/opt/scripts"
source "${SCRIPTS_DIR}/secrets.sh"

# The --apikey flag is available from v1.13 onwards
BW_CLIENTID="$BW_CLIENTID" BW_CLIENTSECRET="$BW_CLIENTSECRET" /usr/local/bin/bw login --apikey --quiet
BW_SESSION="$(/usr/local/bin/bw unlock "$BW_PSWD" --raw)"
export BW_SESSION="${BW_SESSION}"

/usr/local/bin/bw --quiet sync
json_out=$(/usr/local/bin/bw get item "home-ip")
note_id=$(echo "$json_out" | jq --raw-output ".id")

stored_ip=$(echo "$json_out" | jq --raw-output ".notes")
current_ip=$(${SCRIPTS_DIR}/wanip.sh)

if [[ "$stored_ip" == "$current_ip" ]]; then
  echo "IP has not changed"
else
  echo "$json_out" | \
    jq '.notes = "'"${current_ip}"'"' | \
    /usr/local/bin/bw encode | \
    /usr/local/bin/bw --quiet edit item ${note_id}
  echo "IP has been updated"
fi

/usr/local/bin/bw logout --quiet
