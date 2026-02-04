# Quick Start Guide

Get up and running with game decompilation tools in 5 minutes.

## Prerequisites Check

Before starting, ensure you have:

- ✅ OpenCode installed
- ✅ Ghidra downloaded (https://ghidra-sre.org/)
- ✅ Game binary ready to analyze

## Installation (2 minutes)

### Step 1: Run installer

```bash
cd standalone-game-decompilation
./install.sh
```

### Step 2: Restart OpenCode

```bash
opencode
```

### Step 3: Verify

In OpenCode:
```
/decompile-game-binary --help
```

If you see command info, you're ready! ✨

## First Decompilation (10 minutes)

### Scenario: You have a game binary and want compilable source code

#### Step 1: Analyze in Ghidra (manual)

1. Open Ghidra
2. Create new project: `File > New Project`
3. Import your game binary: `File > Import File`
4. Double-click binary to open CodeBrowser
5. When prompted, run Auto Analysis (click "Yes")
6. Wait for analysis to complete (status bar bottom-right)

#### Step 2: Start Ghidra MCP Server

You need a Ghidra MCP server running. See [references/game-decompilation/README.md](references/game-decompilation/README.md#ghidra-mcp-setup) for setup.

#### Step 3: Run Decompilation in OpenCode

```
/decompile-game-binary MyGame
```

Answer the prompts:
- **Project Name**: "My Retro Game"
- **Ghidra Project**: "myproject" (from Step 1)
- **Binary Name**: "game.exe" (from Step 1)
- **Game Type**: "2D Platformer" (or your game type)
- **Goal**: "Generate compilable source and understand architecture"

#### Step 4: Wait for Agent

The agent will:
1. Connect to Ghidra MCP ⏳
2. Retrieve decompiled functions 📥
3. Organize into modules 📁
4. Generate source code 💻
5. Create build system 🔨
6. Write documentation 📝

Takes 5-15 minutes depending on binary size.

#### Step 5: Check Output

```bash
# Source code
ls features/decompiled_source/my-retro-game/

# Documentation
cat docs/decompilation-findings.md

# Build it
cd features/decompiled_source/my-retro-game/
mkdir build && cd build
cmake .. && make
```

Done! You now have compilable source code. 🎉

## First Protocol Analysis (15 minutes)

### Scenario: You want to recreate a shut-down game server

#### Step 1: Run Analysis in OpenCode

```
/analyze-game-protocol /path/to/game.exe
```

Answer the prompts:
- **Game Name**: "Fantasy MMO"
- **Platform**: "Windows x64"
- **Server Status**: "Shut down in 2020"
- **Known Info**: "TCP, port 9999, no encryption"
- **Goal**: "Understand login and player movement"
- **Ghidra**: "Yes"

#### Step 2: Follow Ghidra Guide

The agent will guide you through:
1. Loading binary in Ghidra
2. Finding network functions
3. Analyzing packet structures
4. Documenting message formats

Follow the agent's step-by-step instructions.

#### Step 3: Check Output

```bash
# Protocol specification
cat .planning/game-protocol-analysis/fantasy-mmo/PROTOCOL.md

# Implementation guide
cat .planning/game-protocol-analysis/fantasy-mmo/SERVER-GUIDE.md
```

Use these docs to implement your server! 🚀

## Common Workflows

### Workflow 1: Full Game Preservation

```bash
# 1. Decompile binary
/decompile-game-binary PreserveGame

# 2. Analyze protocol (if multiplayer)
/analyze-game-protocol /path/to/game.exe

# 3. Build and test
cd features/decompiled_source/preserve-game/
mkdir build && cd build
cmake .. && make
./game

# 4. Create patches/improvements
# Edit source code as needed
# Recompile
make
```

### Workflow 2: Server Recreation

```bash
# 1. Analyze protocol
/analyze-game-protocol /path/to/client.exe

# 2. Implement server based on PROTOCOL.md
# Use the SERVER-GUIDE.md as reference

# 3. Test with original client
# Run your server
# Connect original game client
# Verify communication
```

### Workflow 3: Game Porting

```bash
# 1. Decompile to clean source
/decompile-game-binary PortProject

# 2. Review architecture
cat docs/decompilation-findings.md

# 3. Replace platform-specific code
# e.g., DirectX → OpenGL
# Windows APIs → SDL

# 4. Configure for target platform
cd features/decompiled_source/port-project/
# Edit CMakeLists.txt for target platform
mkdir build && cd build
cmake -DPLATFORM=linux ..
make
```

## Tips for Success

### ✅ Do's

- **Start small**: Test with a simple game first
- **Read docs**: Check references/ for detailed guides
- **Analyze thoroughly**: Let Ghidra complete full auto-analysis
- **Document findings**: Take notes as you discover patterns
- **Test incrementally**: Compile modules as they're generated
- **Ask for help**: Use the agent's expertise

### ❌ Don'ts

- **Don't skip Ghidra analysis**: Incomplete analysis = poor results
- **Don't rush**: Decompilation takes time for quality output
- **Don't ignore errors**: Fix compilation issues immediately
- **Don't modify mid-process**: Let agent complete before editing
- **Don't forget backups**: Keep original binaries safe
- **Don't skip legal check**: Verify you have rights to decompile

## Troubleshooting Quick Fixes

### Commands not found
```bash
# Restart OpenCode
pkill opencode
opencode
```

### Ghidra MCP connection failed
```bash
# Check Ghidra MCP server is running
# Verify project name matches exactly
# Check logs for connection errors
```

### Source won't compile
```bash
# Check for missing dependencies
# Install required libraries
# Review compiler error messages
# Start with minimal test file
```

### Agent gets stuck
```bash
# Check system resources (RAM, CPU)
# Try with smaller binary first
# Simplify the request
# Check OpenCode logs
```

## Next Steps

Now that you're up and running:

1. 📖 **Read full README.md** - Complete feature documentation
2. 📚 **Explore references/** - Detailed guides and patterns
3. 🎮 **Try real project** - Start with your favorite game
4. 💬 **Join community** - Discord: https://discord.gg/5JJgD5svVS
5. 🤝 **Share results** - Help others learn from your experience

## Getting Help

Stuck? Help is available:

1. Check [INSTALLATION.md](INSTALLATION.md#troubleshooting) troubleshooting
2. Review [references/](references/) documentation
3. Join GSD Discord community
4. Create GitHub issue with details

---

**Ready to preserve gaming history! 🎮🔍**

*Start with something simple, learn the tools, then tackle your dream project.*
