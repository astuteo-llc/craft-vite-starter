#!/bin/bash
# v1.0.0
# Source color definitions
source ./scripts/theme.sh

# pull_assets_prod_to_stage.sh
# Script to sync assets from Production to Staging using rsync

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/config.sh"

# Optionally source staging-specific config if it exists
STAGING_CONFIG="$DIR/config.staging.sh"
if [ -f "$STAGING_CONFIG" ]; then
    source "$STAGING_CONFIG"
fi

clear
echo -e "${BLUE}Starting asset sync from Production to Staging...${NC}\n"
total_files=0
total_dirs=${#SYNC_DIRS[@]}

for i in "${!SYNC_DIRS[@]}"
do
    dir=${SYNC_DIRS[$i]}
    prod_dir="${PROD_REMOTE_ROOT_PATH}${dir}"
    stage_dir="${STAGE_LOCAL_ROOT_PATH}${dir}"

    echo -e "${YELLOW}-> Syncing ($((i + 1)) / $total_dirs):${NC} ${prod_dir} ${GREEN}to${NC} ${stage_dir}"
    file_count=$(rsync -ai -e "ssh -p ${PROD_SSH_PORT}" "${PROD_REMOTE_SSH_LOGIN}:${prod_dir}/" "${stage_dir}/" | wc -l)
    total_files=$((total_files + file_count))
    echo -e "${GREEN}Completed syncing ${dir} - $file_count files/directories.${NC}\n"
done

echo -e "${GREEN}All assets have been successfully synced from Production to Staging. Total files and directories synced: $total_files.${NC}\n"
read -p "Press Enter to continue..."
clear
exit 0
