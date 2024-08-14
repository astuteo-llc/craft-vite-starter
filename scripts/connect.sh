#!/bin/bash

# v1.0.0
# Source color definitions
source "./scripts/theme.sh"

# connect.sh
# Script to SSH into either production or staging server
clear
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/config.sh"

choose_environment() {
    echo -e "${BLUE}Connect to which server?${NC}"

    echo -e "${YELLOW}1.${NC} Production ${NC}($PROD_REMOTE_SSH_LOGIN)${NC}"
    echo -e "${YELLOW}2.${NC} Staging ${NC}($STAGE_REMOTE_SSH_LOGIN)${NC}"

    echo -e "\n${YELLOW}0.${NC} Exit"

    echo -e "\n${GREEN}Enter your choice (1 or 2):${NC} "
    read choice

    case $choice in
        1)
            echo -e "${YELLOW}Connecting to Production server: $PROD_REMOTE_SSH_LOGIN on port $PROD_SSH_PORT...${NC}"
            ssh -p "$PROD_SSH_PORT" "$PROD_REMOTE_SSH_LOGIN"
            ;;
        2)
            echo -e "${YELLOW}Connecting to Staging server: $STAGE_REMOTE_SSH_LOGIN on port $STAGE_SSH_PORT...${NC}"
            ssh -p "$STAGE_SSH_PORT" "$STAGE_REMOTE_SSH_LOGIN"
            ;;
        0)
            echo -e "${YELLOW}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please enter 1, 2 or 3.${NC}"
            ;;
    esac
}

choose_environment
