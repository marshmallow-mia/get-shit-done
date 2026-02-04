#!/usr/bin/env bash
#
# Uninstallation script for standalone game decompilation tools
# Removes commands and agents from OpenCode configuration directory
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

# Banner
echo -e "${CYAN}"
echo '  ╔═══════════════════════════════════════════════════╗'
echo '  ║   Game Decompilation Tools - Uninstallation      ║'
echo '  ╚═══════════════════════════════════════════════════╝'
echo -e "${RESET}"
echo ""

# Function to expand tilde in paths
expand_tilde() {
    echo "${1/#\~/$HOME}"
}

# Function to detect OpenCode config directory
detect_opencode_dir() {
    if [ ! -z "$OPENCODE_CONFIG_DIR" ]; then
        expand_tilde "$OPENCODE_CONFIG_DIR"
    elif [ ! -z "$OPENCODE_CONFIG" ]; then
        dirname "$(expand_tilde "$OPENCODE_CONFIG")"
    elif [ ! -z "$XDG_CONFIG_HOME" ]; then
        echo "$(expand_tilde "$XDG_CONFIG_HOME")/opencode"
    else
        echo "$HOME/.config/opencode"
    fi
}

# Detect or get config directory
if [ ! -z "$1" ]; then
    CONFIG_DIR="$(expand_tilde "$1")"
    echo -e "${DIM}Using provided directory: $CONFIG_DIR${RESET}"
else
    CONFIG_DIR="$(detect_opencode_dir)"
    echo -e "${DIM}Detected OpenCode directory: $CONFIG_DIR${RESET}"
fi

echo ""

# Check if config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW}OpenCode configuration directory not found: $CONFIG_DIR${RESET}"
    echo "Nothing to uninstall."
    exit 0
fi

# List files to be removed
FILES_TO_REMOVE=(
    "$CONFIG_DIR/commands/decompile-game-binary.md"
    "$CONFIG_DIR/commands/analyze-game-protocol.md"
    "$CONFIG_DIR/agents/gsd-game-decompiler.md"
    "$CONFIG_DIR/agents/gsd-game-protocol-analyzer.md"
)

# Check which files exist
FILES_FOUND=0
echo -e "${BLUE}Files to be removed:${RESET}"
for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${YELLOW}•${RESET} $(basename "$file")"
        ((FILES_FOUND++))
    fi
done

if [ $FILES_FOUND -eq 0 ]; then
    echo -e "${GREEN}No game decompilation tools found.${RESET}"
    echo "Tools may already be uninstalled."
    exit 0
fi

echo ""

# Confirm uninstallation
read -p "$(echo -e ${YELLOW}Remove $FILES_FOUND file\(s\)? \[y/N\]: ${RESET})" -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstallation cancelled.${RESET}"
    exit 0
fi

echo ""

# Remove files
echo -e "${BLUE}Removing files...${RESET}"
REMOVED_COUNT=0
for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ]; then
        rm "$file"
        echo -e "  ${GREEN}✓${RESET} Removed $(basename "$file")"
        ((REMOVED_COUNT++))
    fi
done

echo ""

if [ $REMOVED_COUNT -gt 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║   Uninstallation completed successfully! ✓       ║${RESET}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${CYAN}Removed $REMOVED_COUNT file(s)${RESET}"
    echo ""
    echo -e "${YELLOW}Note:${RESET}"
    echo -e "  • Project files created by the tools are NOT removed"
    echo -e "  • To clean up project files, manually delete:"
    echo -e "    - ${DIM}features/decompiled_source/${RESET}"
    echo -e "    - ${DIM}.planning/game-decompilation/${RESET}"
    echo -e "    - ${DIM}.planning/game-protocol-analysis/${RESET}"
    echo ""
    echo -e "${CYAN}Next step:${RESET}"
    echo -e "  • ${DIM}Restart OpenCode to remove commands from availability${RESET}"
    echo ""
else
    echo -e "${YELLOW}No files were removed.${RESET}"
fi
