#!/bin/bash
# v1.0.0
# Source color definitions
source ./scripts/theme.sh

# pull_db.sh
# Script to pull database from a remote server (production or staging), backup, and restore it locally

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/config.sh"

ENVIRONMENT=${1:-production} # Default to production

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

echo -e "${BLUE}Starting database sync from $ENVIRONMENT...${NC}\n"

echo -e "${YELLOW}-> Step 1/3: Running database backup on the remote server...${NC}"
ssh -p "$SSH_PORT" "$REMOTE_SSH_LOGIN" "cd $REMOTE_ROOT_PATH && ./craft db/backup"

backup_file=$(ssh -p "$SSH_PORT" "$REMOTE_SSH_LOGIN" "ls -t $REMOTE_ROOT_PATH/storage/backups | head -n1")

echo -e "${YELLOW}-> Step 2/3: Downloading the database backup...${NC}"
scp -P "$SSH_PORT" "$REMOTE_SSH_LOGIN:$REMOTE_ROOT_PATH/storage/backups/$backup_file" "$DIR/"

echo -e "${YELLOW}-> Step 3/3: Restoring database from the backup...${NC}"
cd "$LOCAL_ROOT_PATH"
./craft db/restore "$DIR/$backup_file" --dropAllTables

rm "$DIR/$backup_file"

echo -e "${GREEN}Database pull and restore from $ENVIRONMENT completed successfully.${NC}\n"
read -p "Press Enter to continue..."
clear
exit 0
