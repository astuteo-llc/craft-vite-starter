#!/bin/bash
# v1.0.0
# Define colors
source ./scripts/theme.sh

clear
echo -e "${BLUE}Stage Deployment Script${NC}\n"

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${RED}Error: Uncommitted changes detected. The following files have been modified:${NC}"
    git status --porcelain | sed 's/^/  - /'
    echo -e "\n${RED}Please commit or stash these changes before proceeding.${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1/2: Checking current branch...${NC}"
current_branch_name=$(git rev-parse --abbrev-ref HEAD)
unique_tag_name="$current_branch_name"
suffix_counter=1

echo -e "${YELLOW}Step 2/2: Generating a unique tag name...${NC}"
while git rev-parse "staging/$unique_tag_name" >/dev/null 2>&1; do
    unique_tag_name="$current_branch_name-$suffix_counter"
    ((suffix_counter++))
done

git tag "staging/$unique_tag_name"
echo -e "${GREEN}Success: Tag 'staging/$unique_tag_name' has been created.${NC}"

# Prompt user to push the tag
origin_url=$(git remote get-url origin)
echo -e "${YELLOW}Your origin URL: $origin_url${NC}\n"
read -rp "Push the tag 'staging/$unique_tag_name' to trigger a staging deployment? (y/n): " choice

if [[ $choice == "y" || $choice == "Y" ]]; then
    git push origin "staging/$unique_tag_name"
    echo -e "${GREEN}Success: Tag 'staging/$unique_tag_name' has been pushed to the origin. The staging deployment process should initiate shortly.${NC}"
else
    echo -e "${YELLOW}Notice: Tag 'staging/$unique_tag_name' was not pushed. Manual deployment required.${NC}"
fi