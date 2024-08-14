#!/bin/bash
# v1.0.0
# Source color definitions
source ./scripts/theme.sh

# push_assets.sh
# Script to push assets from local to a remote server (staging only)

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/config.sh"

ENVIRONMENT=${1:-staging}

if [ "$ENVIRONMENT" = "production" ]; then
    echo "${RED}Pushing assets to production is not allowed!${NC}"
    exit 1
fi

REMOTE_SSH_LOGIN="$STAGE_REMOTE_SSH_LOGIN"
REMOTE_ROOT_PATH="$STAGE_REMOTE_ROOT_PATH"
SSH_PORT="$STAGE_SSH_PORT"

read -p "${YELLOW}Are you sure you want to push local assets to $ENVIRONMENT? (yes/no) ${NC}" confirm
if [[ $confirm != "yes" ]]; then
    echo "${YELLOW}Operation cancelled.${NC}"
    exit 0
fi

for dir in "${SYNC_DIRS[@]}"
do
    local_dir="${LOCAL_ROOT_PATH}${dir}"
    remote_dir="${REMOTE_ROOT_PATH}${dir}"

    echo "${GREEN}Pushing ${local_dir} to ${remote_dir}${NC}"
    rsync -azP -e "ssh -p ${SSH_PORT}" "${local_dir}/" "${REMOTE_SSH_LOGIN}:${remote_dir}/"
    echo "${GREEN}Pushed ${dir}${NC}"
done

echo "${GREEN}Asset push to $ENVIRONMENT completed.${NC}"

exit 0
