#!/bin/bash

# Needs BACKUP_USER to be specified in secrets.sh

SCRIPTS_DIR=$(realpath "$0" | xargs dirname)
source "${SCRIPTS_DIR}/secrets.sh"

HOME_DIR="/home/${BACKUP_USER}"

declare -a arr=(
        "$HOME_DIR/scripts"
        "$HOME_DIR/.ssh"
        "/etc/hosts"
        # "/etc/nut" # TODO: add in the future
        "/etc/ssh/ssh_config"
        "/etc/ssh/sshd_config"
        "/etc/sudoers"
        "/etc/ufw/user.rules"
        "/etc/ufw/user6.rules"
        "/var/spool/cron/crontabs"
)

TEMP_DIR="$(mktemp -d)"
[ -d "$TEMP_DIR" ] || { >&2 echo "Could not create temp dir" ; exit 1; }

for i in "${arr[@]}"
do
  inner_dir=$(realpath "$i" | xargs dirname)
  mkdir -p "${TEMP_DIR}${inner_dir}"
  rsync -r -t "$i" "${TEMP_DIR}${inner_dir}"
done

chown -R "$BACKUP_USER" "$TEMP_DIR"

echo "$TEMP_DIR"
