#!/bin/bash

# Script that I have set up to be called if MDADM detects an error in my RAID array
# testable with $sudo mdadm --monitor --scan --test -1
# Events are being passed to xmessage via $1 (events), $2 (mdadm device) and $3 component device if relevant

# Needs MDADM_FAILURE_EMAIL_TO and MDADM_FAILURE_EMAIL_FROM in secrets.sh


# Setting variables to readable values
event=$1
array=$2
component=$3 
# Check event and then popup a window with appropriate message based on event
if [ -n "$component" ]; then
	component_msg=", component $3"
else
	component_msg=""
fi

message="${event} event detected on RAID array ${array}${component_msg}\n\nCheck 'man mdadm' for the meaning of this event."

SCRIPTS_DIR=$(realpath "$0" | xargs dirname)
source "${SCRIPTS_DIR}/secrets.sh"


${SCRIPTS_DIR}/email.sh --to "${MDADM_FAILURE_EMAIL_TO}" --from "${MDADM_FAILURE_EMAIL_FROM}" --subject "$(hostname) mdadm: ${event}" --message "${message} $3"
