# Standalone Game Decompilation Tools for OpenCode

This package contains everything needed to run game binary decompilation and protocol analysis outside of the full Get-Shit-Done (GSD) system. These tools are designed to work with OpenCode or any compatible AI coding assistant.

## Overview

This extraction includes two powerful tools for working with legacy game binaries:

1. **Game Binary Decompilation** - Access decompiled code from Ghidra MCP server and generate compilable source code
2. **Game Protocol Analysis** - Reverse engineer video game server protocols using Ghidra

## Contents

```
standalone-game-decompilation/
├── README.md                          # This file
├── INSTALLATION.md                    # Installation instructions
├── commands/                          # Command definitions
│   ├── decompile-game-binary.md      # Decompilation command
│   └── analyze-game-protocol.md       # Protocol analysis command
├── agents/                            # Specialized AI agents
│   ├── gsd-game-decompiler.md        # Decompilation agent
│   └── gsd-game-protocol-analyzer.md  # Protocol analysis agent
└── references/                        # Documentation and guides
    ├── game-decompilation/           # Decompilation guides
    │   ├── README.md                 # Decompilation overview
    │   └── COMMON-GAME-PATTERNS.md   # Common patterns in games
    └── game-protocol-analysis/       # Protocol analysis guides
        ├── README.md                 # Protocol analysis overview
        ├── COMMON-PATTERNS.md        # Common network patterns
        ├── EXAMPLE-OUTPUT.md         # Example outputs
        └── GHIDRA-MCP-GUIDE.md      # Ghidra MCP setup guide
```

## Features

### Game Binary Decompilation (`decompile-game-binary`)

**Purpose:** Transform pre-analyzed Ghidra binaries into clean, compilable source code.

**Prerequisites:**
- Binary already loaded and analyzed in Ghidra MCP server
- Ghidra MCP server running and accessible

**What it does:**
1. Connects to Ghidra MCP server
2. Retrieves decompiled functions from pre-analyzed binary
3. Organizes code into logical modules (rendering, physics, audio, etc.)
4. Renames functions and variables with descriptive names
5. Generates clean C/C++ source code
6. Creates build system (CMake/Makefile)
7. Produces comprehensive documentation

**Output:**
- Compilable source code in `features/decompiled_source/{game}/`
- Documentation in `docs/decompilation-findings.md`
- Build system configuration files
- README with build instructions

**Use cases:**
- Game preservation
- Porting to new platforms
- Understanding game implementations
- Adding features to legacy games

### Game Protocol Analysis (`analyze-game-protocol`)

**Purpose:** Reverse engineer video game server protocols for shut-down or legacy games.

**Prerequisites:**
- Game binary/executable
- Ghidra installed (optional but recommended)

**What it does:**
1. Guides you through binary analysis with Ghidra
2. Identifies network functions and message formats
3. Extracts authentication mechanisms
4. Documents protocol specifications
5. Provides server implementation guides

**Output:**
- Protocol specification in `.planning/game-protocol-analysis/{game}/PROTOCOL.md`
- Server implementation guide
- Analysis session logs

**Use cases:**
- Recreating shut-down game servers
- Understanding multiplayer implementations
- Server emulation projects
- Network security research

## Quick Start

### 1. Install to OpenCode

See [INSTALLATION.md](INSTALLATION.md) for detailed instructions.

**Quick install:**

```bash
cd standalone-game-decompilation
./install.sh
```

Or manually:

```bash
# Copy to OpenCode config directory
mkdir -p ~/.config/opencode/commands
mkdir -p ~/.config/opencode/agents

cp commands/* ~/.config/opencode/commands/
cp agents/* ~/.config/opencode/agents/
```

### 2. Restart OpenCode

```bash
# Restart OpenCode to load new commands
opencode
```

### 3. Verify Installation

In OpenCode, type:

```
/decompile-game-binary --help
```

or

```
/analyze-game-protocol --help
```

### 4. Start Decompiling

**For game decompilation (requires Ghidra MCP):**

```
/decompile-game-binary MyGame
```

**For protocol analysis:**

```
/analyze-game-protocol /path/to/game.exe
```

## Prerequisites

### Required

- **OpenCode** or compatible AI coding assistant
- **Node.js** 16.7.0 or later (if using OpenCode)

### For Decompilation

- **Ghidra** - NSA's reverse engineering tool
  - Download: https://ghidra-sre.org/
  - Version: 10.0 or later recommended
- **Ghidra MCP Server** - Model Context Protocol server for Ghidra
  - Binary must be pre-analyzed in Ghidra before decompilation

### For Protocol Analysis

- **Ghidra** (optional but strongly recommended)
- Network analysis tools (Wireshark, tcpdump) if analyzing live traffic

### Build Tools (for compiling decompiled code)

- **C/C++ Compiler** (GCC, Clang, or MSVC)
- **CMake** 3.10 or later (recommended)
- **Make** or equivalent build tool

## Directory Structure After Installation

Once installed in OpenCode, the files will be in:

```
~/.config/opencode/
├── commands/
│   ├── decompile-game-binary.md
│   └── analyze-game-protocol.md
└── agents/
    ├── gsd-game-decompiler.md
    └── gsd-game-protocol-analyzer.md
```

Reference documentation stays in this package directory for easy access.

## Usage Examples

### Example 1: Decompile a Legacy Game

```
# In OpenCode
/decompile-game-binary RetroRacer

> Project Name? "Retro Racer 1995"
> Ghidra Project? "retro-racer-analysis"
> Binary Name? "racer.exe"
> Game Type? "3D Racing Game"
> Decompilation Goal? "Port to modern platforms and add online multiplayer"
```

The agent will:
1. Connect to Ghidra MCP
2. Retrieve all decompiled functions
3. Organize into rendering, physics, audio, input systems
4. Generate clean source code
5. Create build system
6. Document architecture

Output in: `features/decompiled_source/retro-racer/`

### Example 2: Analyze Server Protocol

```
# In OpenCode
/analyze-game-protocol ./MMO_Client.exe

> Game name? "Fantasy MMO"
> Platform? "Windows x64"
> Analysis goal? "Understand login and player movement protocol"
```

The agent will:
1. Guide Ghidra analysis of network functions
2. Identify packet structures
3. Document authentication flow
4. Create protocol specification

Output in: `.planning/game-protocol-analysis/fantasy-mmo/`

## Workflow

### Decompilation Workflow

```
1. Analyze binary in Ghidra (manual step)
   ↓
2. Start Ghidra MCP server
   ↓
3. Run /decompile-game-binary in OpenCode
   ↓
4. Agent connects to Ghidra MCP
   ↓
5. Agent retrieves decompiled code
   ↓
6. Agent organizes and renames functions
   ↓
7. Agent generates source code
   ↓
8. Source code in features/decompiled_source/
   ↓
9. Compile and test
```

### Protocol Analysis Workflow

```
1. Obtain game binary
   ↓
2. Run /analyze-game-protocol in OpenCode
   ↓
3. Follow Ghidra analysis guide
   ↓
4. Agent helps identify network functions
   ↓
5. Agent documents packet formats
   ↓
6. Protocol spec in .planning/game-protocol-analysis/
   ↓
7. Implement server using spec
```

## Differences from Full GSD

This standalone extraction is simplified compared to the full Get-Shit-Done system:

**Removed dependencies:**
- No GSD project structure required (PROJECT.md, ROADMAP.md, etc.)
- No model profile configuration
- No milestone/phase management
- Standalone commands work independently

**Simplified workflow:**
- Direct command execution (no orchestrator overhead)
- Manual session management
- Simpler directory structure

**What's preserved:**
- Full decompilation capabilities
- Protocol analysis features
- Agent expertise and prompts
- Reference documentation
- All core functionality

## Troubleshooting

### Commands not found after installation

**Solution:**
- Restart OpenCode to reload commands
- Verify files exist in `~/.config/opencode/commands/`
- Check file permissions (should be readable)

### Ghidra MCP connection failed

**Solution:**
- Verify Ghidra MCP server is running
- Check the binary is loaded in Ghidra project
- Confirm project name matches exactly
- Review Ghidra MCP logs for errors

### Decompiled code won't compile

**Solution:**
- Check for missing header files
- Verify all dependencies are installed
- Review compiler error messages
- Consult `docs/decompilation-findings.md` for known issues
- Test with a simple file first to isolate the problem

### Agent not spawning or getting stuck

**Solution:**
- Check OpenCode logs for errors
- Verify agent file is in correct location
- Ensure sufficient system resources
- Try simplifying the initial request

## Advanced Usage

### Custom Ghidra MCP Server

If using a custom Ghidra MCP server endpoint:

```bash
# Set environment variable before starting OpenCode
export GHIDRA_MCP_ENDPOINT="http://localhost:9000"
opencode
```

### Batch Processing Multiple Binaries

Create a script:

```bash
#!/bin/bash
for binary in *.exe; do
    echo "Processing $binary..."
    opencode --script "decompile-game-binary \"$(basename $binary .exe)\""
done
```

### Integrating with CI/CD

Use OpenCode in non-interactive mode:

```bash
# In your CI pipeline
opencode --non-interactive --script "analyze-game-protocol ./game.exe"
```

## Contributing

If you find issues or have improvements:

1. Create an issue in the original GSD repository
2. Submit a pull request with fixes
3. Share your decompilation experiences

Repository: https://github.com/glittercowboy/get-shit-done

## Legal Considerations

**Important:** Reverse engineering and decompilation may have legal implications:

- Check the game's EULA/Terms of Service
- Consider copyright and intellectual property laws in your jurisdiction
- Use for educational, preservation, or personal purposes
- Don't redistribute copyrighted game code without permission
- Respect the original developers' work

This tool is provided for legitimate reverse engineering purposes such as:
- Game preservation when official servers are shut down
- Educational study of game architecture
- Accessibility improvements
- Personal use modifications
- Security research

## Support

For help with these tools:

1. Read the reference documentation in `references/`
2. Check the original GSD documentation
3. Join the GSD Discord: https://discord.gg/5JJgD5svVS
4. Create an issue on GitHub

## Credits

These tools are extracted from **Get Shit Done** by TÂCHES.

- Original project: https://github.com/glittercowboy/get-shit-done
- Author: TÂCHES (glittercowboy)
- License: MIT

## License

MIT License - See LICENSE file in the original GSD repository.

---

**Happy decompiling! 🎮🔍**

*Preserve gaming history, one binary at a time.*
