#!/usr/bin/env bash
#
# Verification script for standalone game decompilation package
# Checks package integrity and completeness
#

# Don't exit on error, we want to count failures
set +e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

echo -e "${CYAN}"
echo '  ╔═══════════════════════════════════════════════════╗'
echo '  ║   Package Verification                            ║'
echo '  ╚═══════════════════════════════════════════════════╝'
echo -e "${RESET}"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

PASS=0
FAIL=0

check_file() {
    local file="$1"
    local desc="$2"
    
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${RESET} $desc"
        ((PASS++))
        return 0
    else
        echo -e "  ${RED}✗${RESET} $desc ${DIM}(missing: $file)${RESET}"
        ((FAIL++))
        return 1
    fi
}

check_dir() {
    local dir="$1"
    local desc="$2"
    
    if [ -d "$dir" ]; then
        echo -e "  ${GREEN}✓${RESET} $desc"
        ((PASS++))
        return 0
    else
        echo -e "  ${RED}✗${RESET} $desc ${DIM}(missing: $dir)${RESET}"
        ((FAIL++))
        return 1
    fi
}

check_executable() {
    local file="$1"
    local desc="$2"
    
    if [ -x "$file" ]; then
        echo -e "  ${GREEN}✓${RESET} $desc"
        ((PASS++))
        return 0
    else
        echo -e "  ${RED}✗${RESET} $desc ${DIM}(not executable: $file)${RESET}"
        ((FAIL++))
        return 1
    fi
}

echo -e "${CYAN}Documentation Files${RESET}"
check_file "README.md" "README.md"
check_file "INSTALLATION.md" "INSTALLATION.md"
check_file "QUICKSTART.md" "QUICKSTART.md"
check_file "MANIFEST.md" "MANIFEST.md"
echo ""

echo -e "${CYAN}Installation Scripts${RESET}"
check_file "install.sh" "install.sh exists"
check_executable "install.sh" "install.sh is executable"
check_file "uninstall.sh" "uninstall.sh exists"
check_executable "uninstall.sh" "uninstall.sh is executable"
echo ""

echo -e "${CYAN}Command Files${RESET}"
check_dir "commands" "commands directory"
check_file "commands/decompile-game-binary.md" "decompile-game-binary.md"
check_file "commands/analyze-game-protocol.md" "analyze-game-protocol.md"
echo ""

echo -e "${CYAN}Agent Files${RESET}"
check_dir "agents" "agents directory"
check_file "agents/gsd-game-decompiler.md" "gsd-game-decompiler.md"
check_file "agents/gsd-game-protocol-analyzer.md" "gsd-game-protocol-analyzer.md"
echo ""

echo -e "${CYAN}Reference Documentation${RESET}"
check_dir "references" "references directory"
check_dir "references/game-decompilation" "game-decompilation directory"
check_file "references/game-decompilation/README.md" "Decompilation README"
check_file "references/game-decompilation/COMMON-GAME-PATTERNS.md" "Common Game Patterns"
check_dir "references/game-protocol-analysis" "game-protocol-analysis directory"
check_file "references/game-protocol-analysis/README.md" "Protocol Analysis README"
check_file "references/game-protocol-analysis/COMMON-PATTERNS.md" "Common Network Patterns"
check_file "references/game-protocol-analysis/EXAMPLE-OUTPUT.md" "Example Output"
check_file "references/game-protocol-analysis/GHIDRA-MCP-GUIDE.md" "Ghidra MCP Guide"
echo ""

echo -e "${CYAN}Examples${RESET}"
check_dir "examples" "examples directory"
echo ""

# Summary
echo -e "${CYAN}═══════════════════════════════════════════════════${RESET}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! ($PASS/$PASS)${RESET}"
    echo ""
    echo -e "${CYAN}Package is complete and ready for distribution.${RESET}"
    echo ""
    echo -e "${DIM}Package size: $(du -sh . | cut -f1)${RESET}"
    echo -e "${DIM}Total files: $(find . -type f | wc -l)${RESET}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some checks failed ($PASS passed, $FAIL failed)${RESET}"
    echo ""
    echo -e "${YELLOW}Package may be incomplete or corrupted.${RESET}"
    echo ""
    exit 1
fi
