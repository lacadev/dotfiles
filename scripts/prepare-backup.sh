#!/bin/bash

# This script will be called by backup.sh
# The idea is that this will set up a temp directory
# with all the files that need to be backed up copied
# inside. After, backup.sh will backup those.

# Needs BACKUP_USER and BACKUP_FILES to be specified in secrets.sh

# Also needs to be executed with sudo, and if called
# by the backup-host.sh script, you'll need to update
# your sudoers files so that $ sudo prepare-backup.sh
# doesn't ask for a password:
# $ sudo visudo
# And then add at the end:
# <username> ALL = (root) NOPASSWD: /home/<username>/scripts/prepare-backup.sh

SCRIPTS_DIR=$(realpath "$0" | xargs dirname)
source "${SCRIPTS_DIR}/secrets.sh"

if [ "$1" = "--nas" ]; then
  NAS=true
else
  NAS=false
fi


TEMP_DIR="$(mktemp -d)"
[ -d "$TEMP_DIR" ] || { >&2 echo "Could not create temp dir" ; exit 1; }

if [ "$NAS" = true ]; then
  for i in "${BACKUP_NAS[@]}"
  do
    # Check that file exists, be it a node, directory, etc.
    # so that we can use the same list for all computers
    # without rsync failing if a file doesn't exist
    if [ -e "$i" ]; then
      inner_dir=$(realpath "$i" | xargs dirname)
      mkdir -p "${TEMP_DIR}${inner_dir}"
      ln "$i" "${TEMP_DIR}${i}"
    fi
  done
else
  # Copy files. We cannot just create hard links
  # because some files are owned by root
  for i in "${BACKUP_HOST[@]}"
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
fi


chown -R "$BACKUP_USER" "$TEMP_DIR"

echo "$TEMP_DIR"
