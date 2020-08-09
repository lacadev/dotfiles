#!/bin/bash

# This script will be called by backup.sh
# The idea is that this will set up a temp directory
# with all the files that need to be backed up copied
# inside. After, backup.sh will backup those.

# Needs BACKUP_USER to be specified in secrets.sh

# Also needs to be executed with sudo, and if called
# by the backup-host.sh script, you'll need to update
# your sudoers files so that $ sudo prepare-backup.sh
# doesn't ask for a password:
# $ sudo visudo
# And then add at the end:
# <username> ALL = (root) NOPASSWD: /home/<username>/scripts/prepare-backup.sh

SCRIPTS_DIR=$(realpath "$0" | xargs dirname)
source "${SCRIPTS_DIR}/secrets.sh"

HOME_DIR="/home/${BACKUP_USER}"


declare -a arr=(
        "$HOME_DIR/.ssh"
        "/etc/hosts"
        "/etc/nut"
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
  # Check that file exists, be it a node, directory, etc.
  # so that we can use the same list for all computers
  # without rsync failing if a file doesn't exist
  if [ -e "$i" ]; then
    inner_dir=$(realpath "$i" | xargs dirname)
    mkdir -p "${TEMP_DIR}${inner_dir}"
    rsync -r -t -L "$i" "${TEMP_DIR}${inner_dir}"
  fi
done

chown -R "$BACKUP_USER" "$TEMP_DIR"

echo "$TEMP_DIR"
