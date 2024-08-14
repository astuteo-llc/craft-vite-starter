#!/bin/bash

# v1.0.0
# config.sh
# Configuration for remote server connection and directories to sync

# PRODUCTION
PROD_SERVER_IP="[prodIp]"
PROD_SSH_PORT="22"
PROD_SSH_USERNAME="[prodSshUsername]"
PROD_REMOTE_ROOT_PATH="[prodPath]" # Should end in "/" and be the full path
PROD_REMOTE_SSH_LOGIN="$PROD_SSH_USERNAME@$PROD_SERVER_IP"

# STAGING
STAGE_SERVER_IP="[stagingIp]"
STAGE_SSH_PORT="22"
STAGE_SSH_USERNAME="[stagingSshUsername]"
STAGE_REMOTE_ROOT_PATH="[stagingPath]" # Should end in "/" and be the full path
STAGE_REMOTE_SSH_LOGIN="$STAGE_SSH_USERNAME@$STAGE_SERVER_IP"

# LOCAL:
# if using DDEV this is almost always /var/www/html/
# Able to be overridden in the .env file by setting LOCAL_ROOT_PATH
LOCAL_ROOT_PATH="/var/www/html/" # Should end in "/" Change if different

# SYNC DIRECTORIES
# List of directories to sync between local and remote, relative to respective path
#
# Example: SYNC_DIRS=(
#    "web/uploads"
#    "web/another_directory"
#    )
SYNC_DIRS=(
    "public_html/uploads"
)

# ---- END CUSTOM CONFIGURATION ----

# Check if LOCAL_ROOT_PATH and CRAFT_ENVIRONMENT are overridden in the .env file
if [ -f "$ENV_PATH" ]; then
    # Read LOCAL_ROOT_PATH from .env file if available
    OVERRIDE_PATH=$(grep -m 1 "^LOCAL_ROOT_PATH=" "$ENV_PATH" | cut -d '=' -f2-)
    if [ -n "$OVERRIDE_PATH" ]; then
        LOCAL_ROOT_PATH=$OVERRIDE_PATH
    fi

    # Read CRAFT_ENVIRONMENT from .env file if available
    CRAFT_ENVIRONMENT=$(grep -m 1 "^CRAFT_ENVIRONMENT=" "$ENV_PATH" | cut -d '=' -f2-)
fi

# Ensure LOCAL_ROOT_PATH and REMOTE_ROOT_PATH end with a "/"
[[ "${LOCAL_ROOT_PATH}" != */ ]] && LOCAL_ROOT_PATH="${LOCAL_ROOT_PATH}/"
[[ "${PROD_REMOTE_ROOT_PATH}" != */ ]] && PROD_REMOTE_ROOT_PATH="${PROD_REMOTE_ROOT_PATH}/"
[[ "${STAGE_REMOTE_ROOT_PATH}" != */ ]] && STAGE_REMOTE_ROOT_PATH="${STAGE_REMOTE_ROOT_PATH}/"
