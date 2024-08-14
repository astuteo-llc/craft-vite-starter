#!/bin/bash
# v1.0.1
# Source color definitions
source ./scripts/theme.sh

NOTES_FILE="./scripts/notes.txt"

# options.sh
# Script to present a menu for running different scripts
clear
DIR="$(dirname "${BASH_SOURCE[0]}")"

display_notices() {
    if [ -f "$NOTES_FILE" ] && [ -s "$NOTES_FILE" ]; then
        echo -e "${GREEN}Project Notices:${NC}"
        echo -e "${NC}---------------------------------${NC}"
        cat "$NOTES_FILE"
        echo -e "${NC}---------------------------------${NC}"
    fi
}

show_menu() {
    echo
    echo -e "${BLUE}Which option would you like to run?${NC}"

    echo -e "\n${YELLOW}Production:${NC}"
    echo -e "${NC}---------------------------------${NC}"
    echo -e "${YELLOW}1.${NC} Create a Release"
    echo -e "${YELLOW}2.${NC} ⬇️ Pull Assets from Production"
    echo -e "${YELLOW}3.${NC} ⬇️️ Sync Database from Production"

    echo -e "\n${YELLOW}Staging:${NC}"
    echo -e "${NC}---------------------------------${NC}"
    echo -e "${YELLOW}4.${NC} Create Staging Tag"
    echo -e "${YELLOW}5.${NC} ⬇️ Pull Assets from Staging"
    echo -e "${YELLOW}6.${NC} ⬇️️ Sync Database from Staging"
    echo -e "${YELLOW}7.${NC} ⬆️ Push Assets to Staging"
    echo -e "${YELLOW}8.${NC} ⬆️️ Push Database to Staging"
    echo -e "${YELLOW}9.${NC} ⬆️️ Sync Assets Production to Staging"

    echo -e "\n${YELLOW}Server Access:${NC}"
    echo -e "${NC}---------------------------------${NC}"
    echo -e "${YELLOW}10.${NC} 🖥️  SSH into a Server"

    echo -e "\n${YELLOW}Other:${NC}"
    echo -e "${NC}---------------------------------${NC}"
    echo -e "${YELLOW}0.${NC} Exit"

    echo -e "\n${GREEN}Enter your choice (1-10):${NC}"
    read choice

    case $choice in
        1)
            echo -e "${YELLOW}Creating a Production Release...${NC}"
            $DIR/release.sh production
            ;;
        2)
            echo -e "${YELLOW}Downloading Assets from Production...${NC}"
            $DIR/pull_assets.sh production
            ;;
        3)
            echo -e "${YELLOW}Syncing Database from Production...${NC}"
            $DIR/pull_db.sh production
            ;;
        4)
            echo -e "${YELLOW}Creating a Staging Release...${NC}"
            $DIR/stage.sh
            ;;
        5)
            echo -e "${YELLOW}Downloading Assets from Staging...${NC}"
            $DIR/pull_assets.sh staging
            ;;
        6)
            echo -e "${YELLOW}Syncing Database from Staging...${NC}"
            $DIR/pull_db.sh staging
            ;;
        7)
            echo -e "${YELLOW}Pushing Assets to Staging...${NC}"
            $DIR/push_assets.sh staging
            ;;
        8)
            echo -e "${YELLOW}Pushing Database to Staging...${NC}"
            $DIR/push_db.sh staging
            ;;
        9)
            echo -e "${YELLOW}Syncing Production Assets to Staging...${NC}"
            $DIR/pull_assets_prod_to_stage.sh
            ;;
        10)
            echo -e "${YELLOW}Connecting to a Server...${NC}"
            $DIR/connect.sh
            ;;
        0)
            echo -e "${YELLOW}Bye!${NC}"
            clear
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please enter a valid number.${NC}"
            ;;
    esac
}

display_notices
show_menu
