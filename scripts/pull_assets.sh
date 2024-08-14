#!/bin/bash
# v1.0.0
# Source color definitions
source ./scripts/theme.sh

# pull_assets.sh
# Script to pull assets from a remote server (production or staging) using rsync

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/config.sh"

ENVIRONMENT=${1:-production} # Default to production if no argument is provided

if [ "$ENVIRONMENT" = "staging" ]; then
    REMOTE_SSH_LOGIN="$STAGE_REMOTE_SSH_LOGIN"
    REMOTE_ROOT_PATH="$STAGE_REMOTE_ROOT_PATH"
    SSH_PORT="$STAGE_SSH_PORT"
else
    REMOTE_SSH_LOGIN="$PROD_REMOTE_SSH_LOGIN"
    REMOTE_ROOT_PATH="$PROD_REMOTE_ROOT_PATH"
    SSH_PORT="$PROD_SSH_PORT"
fi
clear

echo -e "${BLUE}Starting asset sync from $ENVIRONMENT...${NC}\n"
total_files=0
total_dirs=${#SYNC_DIRS[@]}

for i in "${!SYNC_DIRS[@]}"
do
    dir=${SYNC_DIRS[$i]}
    local_dir="${LOCAL_ROOT_PATH}${dir}"
    remote_dir="${REMOTE_ROOT_PATH}${dir}"

    echo -e "${YELLOW}-> Syncing ($((i + 1)) / $total_dirs):${NC} ${remote_dir} ${GREEN}to${NC} ${local_dir}"
    file_count=$(rsync -ai --info=NAME -e "ssh -p ${SSH_PORT}" "${REMOTE_SSH_LOGIN}:${remote_dir}/" "${local_dir}/" | wc -l)
    total_files=$((total_files + file_count))
    echo -e "${GREEN}Completed syncing ${dir} - $file_count files/directories.${NC}\n"
done

echo -e "${GREEN}All assets have been successfully synced from $ENVIRONMENT. Total files and directories synced: $total_files.${NC}\n"
read -p "Press Enter to continue..."
clear
exit 0
