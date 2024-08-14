#!/bin/bash
# v1.0.0
# Source color definitions
source ./scripts/theme.sh

# push_db.sh
# Script to push local database to a remote server (staging only)

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/config.sh"

ENVIRONMENT=${1:-staging}

if [ "$ENVIRONMENT" = "production" ]; then
    echo "${RED}Pushing database to production is not allowed!${NC}"
    exit 1
fi

REMOTE_SSH_LOGIN="$STAGE_REMOTE_SSH_LOGIN"
REMOTE_ROOT_PATH="$STAGE_REMOTE_ROOT_PATH"
SSH_PORT="$STAGE_SSH_PORT"

read -p "${YELLOW}Are you sure you want to push the local database to $ENVIRONMENT? (yes/no) ${NC}" confirm
if [[ $confirm != "yes" ]]; then
    echo "${YELLOW}Operation cancelled.${NC}"
    exit 0
fi

echo "${GREEN}Creating local database backup...${NC}"
./craft db/backup

backup_file=$(ls -t "$LOCAL_ROOT_PATH/storage/backups" | head -n1)

echo "${GREEN}Pushing the database backup to the remote server...${NC}"
scp -P "$SSH_PORT" "$LOCAL_ROOT_PATH/storage/backups/$backup_file" "$REMOTE_SSH_LOGIN:$REMOTE_ROOT_PATH/storage/backups/"

echo "${GREEN}Restoring database on the remote server and cleaning up...${NC}"
ssh -p "$SSH_PORT" "$REMOTE_SSH_LOGIN" "\
    cd $REMOTE_ROOT_PATH && \
    ./craft db/restore storage/backups/$backup_file && \
    rm storage/backups/$backup_file"

echo "${GREEN}Database push to $ENVIRONMENT completed.${NC}"

exit 0
