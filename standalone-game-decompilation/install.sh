#!/usr/bin/env bash
#
# Installation script for standalone game decompilation tools
# Installs commands and agents to OpenCode configuration directory
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
echo '  ║   Game Decompilation Tools - Installation        ║'
echo '  ╚═══════════════════════════════════════════════════╝'
echo -e "${RESET}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to expand tilde in paths
expand_tilde() {
    echo "${1/#\~/$HOME}"
}

# Function to detect OpenCode config directory
detect_opencode_dir() {
    # Priority order:
    # 1. OPENCODE_CONFIG_DIR environment variable
    # 2. OPENCODE_CONFIG env var (use its directory)
    # 3. XDG_CONFIG_HOME/opencode
    # 4. Default: ~/.config/opencode
    
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

# Verify source files exist
if [ ! -d "$SCRIPT_DIR/commands" ] || [ ! -d "$SCRIPT_DIR/agents" ]; then
    echo -e "${RED}Error: Cannot find commands/ or agents/ directory${RESET}"
    echo "Make sure you're running this script from the standalone-game-decompilation directory"
    exit 1
fi

# Create target directories
echo -e "${BLUE}Creating directories...${RESET}"
mkdir -p "$CONFIG_DIR/commands"
mkdir -p "$CONFIG_DIR/agents"

# Check if directories were created successfully
if [ ! -d "$CONFIG_DIR/commands" ] || [ ! -d "$CONFIG_DIR/agents" ]; then
    echo -e "${RED}Error: Failed to create directories${RESET}"
    echo "Check permissions for: $CONFIG_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Directories created${RESET}"
echo ""

# Copy command files
echo -e "${BLUE}Installing command files...${RESET}"
COMMANDS_INSTALLED=0
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        cmd_name=$(basename "$cmd_file")
        cp "$cmd_file" "$CONFIG_DIR/commands/"
        echo -e "  ${GREEN}✓${RESET} $cmd_name"
        ((COMMANDS_INSTALLED++))
    fi
done

if [ $COMMANDS_INSTALLED -eq 0 ]; then
    echo -e "${RED}Error: No command files found${RESET}"
    exit 1
fi

echo ""

# Copy agent files
echo -e "${BLUE}Installing agent files...${RESET}"
AGENTS_INSTALLED=0
for agent_file in "$SCRIPT_DIR/agents"/*.md; do
    if [ -f "$agent_file" ]; then
        agent_name=$(basename "$agent_file")
        cp "$agent_file" "$CONFIG_DIR/agents/"
        echo -e "  ${GREEN}✓${RESET} $agent_name"
        ((AGENTS_INSTALLED++))
    fi
done

if [ $AGENTS_INSTALLED -eq 0 ]; then
    echo -e "${RED}Error: No agent files found${RESET}"
    exit 1
fi

echo ""

# Set proper permissions
echo -e "${BLUE}Setting file permissions...${RESET}"
chmod 644 "$CONFIG_DIR/commands"/*.md 2>/dev/null || true
chmod 644 "$CONFIG_DIR/agents"/*.md 2>/dev/null || true
echo -e "${GREEN}✓ Permissions set${RESET}"
echo ""

# Verify installation
echo -e "${BLUE}Verifying installation...${RESET}"
VERIFICATION_PASSED=true

# Check command files
if [ ! -f "$CONFIG_DIR/commands/decompile-game-binary.md" ]; then
    echo -e "${RED}✗ decompile-game-binary.md not found${RESET}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✓ decompile-game-binary.md${RESET}"
fi

if [ ! -f "$CONFIG_DIR/commands/analyze-game-protocol.md" ]; then
    echo -e "${RED}✗ analyze-game-protocol.md not found${RESET}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✓ analyze-game-protocol.md${RESET}"
fi

# Check agent files
if [ ! -f "$CONFIG_DIR/agents/gsd-game-decompiler.md" ]; then
    echo -e "${RED}✗ gsd-game-decompiler.md not found${RESET}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✓ gsd-game-decompiler.md${RESET}"
fi

if [ ! -f "$CONFIG_DIR/agents/gsd-game-protocol-analyzer.md" ]; then
    echo -e "${RED}✗ gsd-game-protocol-analyzer.md not found${RESET}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✓ gsd-game-protocol-analyzer.md${RESET}"
fi

echo ""

if [ "$VERIFICATION_PASSED" = true ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║   Installation completed successfully! 🎉        ║${RESET}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${CYAN}Commands installed:${RESET}"
    echo -e "  • ${YELLOW}/decompile-game-binary${RESET} - Decompile game binaries via Ghidra MCP"
    echo -e "  • ${YELLOW}/analyze-game-protocol${RESET} - Analyze game server protocols"
    echo ""
    echo -e "${CYAN}Next steps:${RESET}"
    echo -e "  1. ${DIM}Restart OpenCode to load new commands${RESET}"
    echo -e "  2. ${DIM}Verify with: ${YELLOW}/decompile-game-binary --help${RESET}"
    echo -e "  3. ${DIM}Read README.md for usage examples${RESET}"
    echo -e "  4. ${DIM}Check references/ for documentation${RESET}"
    echo ""
    echo -e "${DIM}Installation directory: $CONFIG_DIR${RESET}"
    echo ""
else
    echo -e "${RED}Installation completed with errors${RESET}"
    echo "Some files may not have been installed correctly."
    echo "Please check the error messages above."
    exit 1
fi
