#! /bin/bash

# This script should be run on Windows using WSL2
# It needs borgbackup installed and relies on having
# the target's ssh config stored in ~/.ssh/config on the
# local system

# Set default values
UMOUNT_AFTER_FINISH=false

# Parse args
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -p|--partition)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        HDD_PARTITION=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -u|--umount)
      UMOUNT_AFTER_FINISH=true
      shift
      ;;
    --nas)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        NAS_DIR=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# Set positional arguments in their proper place
# From man set:
# --  If no arguments follow this option, then the positional parameters are unset. 
#     Otherwise, the positional parameters are set to the arguments, 
#     even if some of them begin with a '-'
eval set -- "$PARAMS"


# Check that all required arguments were given
[ -z "${HDD_PARTITION}" ] && { >&2 echo "Please specify the external HDD partition" ; exit 1; }
[ -z "$1" ] && { >&2 echo "Please specify the target's name" ; exit 1; }

HDD_DIR="/mnt/e"
TARGET="$1"
TARGET_ROOT="/mnt/${TARGET}"
REPO="${HDD_DIR}/backups/${TARGET}"

# Clean up temp dir from sshfs mount
cleanup () {
  [ ! -z $REMOTE_DIR ] && ssh $TARGET "rm -r $REMOTE_DIR"

  sudo umount "${TEMP_DIR}" && rmdir "${TEMP_DIR}"

  [ "${UMOUNT_AFTER_FINISH}" = true ] && \
    [[ $(findmnt -M "${HDD_DIR}") ]] && \
    sudo umount "${HDD_DIR}"
}

# Make sure we cleanup even if the script is interrupted with Ctrl+C
# or some other specific signals
trap cleanup 1 2 3 6

# Mount backup HDD if not already mounted
sudo mkdir -p "${HDD_DIR}"
sudo chown "${USER}" "${HDD_DIR}"
[ -d $HDD_DIR ] || { >&2 echo "Failed to create ${HDD_DIR} directory" ; exit 1; }
[[ $(findmnt -M "${HDD_DIR}") ]] || \
  sudo mount -t drvfs "${HDD_PARTITION}:" "${HDD_DIR}" || \
  { >&2 echo "Could not mount ${HDD_PARTITION}: partition on ${HDD_DIR} dir" ; exit 1; }

# Copy files to backup from target to local system
TEMP_DIR="$(mktemp -d)"
[ -d $TEMP_DIR ] || { >&2 echo "Failed to create temp dir $TEMP_DIR" ; exit 1; }
if [ -z "$NAS_DIR" ]; then
  REMOTE_DIR="$(ssh $TARGET 'sudo ~/scripts/prepare-backup.sh')"
else
  REMOTE_DIR="$(ssh $TARGET 'sudo ~/scripts/prepare-backup.sh --nas')"
fi
sshfs -F "$HOME/.ssh/config" "$TARGET:$REMOTE_DIR" "$TEMP_DIR"
[ -z $REMOTE_DIR ] && { >&2 echo "Failed to execute the prepare-backup.sh script on target $TARGET" ; exit 1; }


# If borg repo doesn't exist, create it
[ -d ${REPO} ] || borg init --encryption none "${REPO}"

# Perform backup
# BORG_RELOCATED_REPO_ACCESS_IS_OK=yes \ # uncomment if using temp dirs to mount the HDD
pushd $TEMP_DIR && \
  borg create \
  --stats \
  --progress \
  --compression zlib,9 \
  --exclude-caches \
  "${REPO}::{now}" \
  "." && \
  popd

# Prune backups that are more than 26 weeks old
borg prune --stats --list --keep-within=26w "${REPO}"

# Cleanup
cleanup
