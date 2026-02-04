# Using the Standalone Package

This guide explains how to use the extracted game decompilation tools in your OpenCode instance.

## What You Have

The `standalone-game-decompilation/` directory contains everything needed to decompile game binaries and analyze protocols independently of the full GSD system.

## Quick Installation for OpenCode

### Option 1: Automated (Recommended)

```bash
cd standalone-game-decompilation
./install.sh
```

Restart OpenCode and you're done!

### Option 2: Manual

```bash
# Copy to OpenCode config
cp commands/*.md ~/.config/opencode/commands/
cp agents/*.md ~/.config/opencode/agents/

# Restart OpenCode
opencode
```

## Available Commands

Once installed, you have two main commands:

### 1. `/decompile-game-binary` - Decompile Games

**Purpose:** Transform Ghidra-analyzed binaries into clean, compilable C/C++ source code.

**Usage:**
```
/decompile-game-binary ProjectName
```

**Requirements:**
- Binary must be pre-analyzed in Ghidra
- Ghidra MCP server must be running
- Project name from Ghidra

**What you get:**
- Clean source code in `features/decompiled_source/`
- Build system (CMake + Makefile)
- Comprehensive documentation
- Compilable output

### 2. `/analyze-game-protocol` - Reverse Engineer Protocols

**Purpose:** Understand game server protocols for recreation.

**Usage:**
```
/analyze-game-protocol /path/to/game.exe
```

**Requirements:**
- Game binary/executable
- Ghidra (optional but recommended)

**What you get:**
- Protocol specification
- Server implementation guide
- Message format documentation
- Analysis session logs

## Typical Workflows

### Workflow A: Full Decompilation

```bash
# 1. Start in your project directory
cd ~/my-game-preservation-project

# 2. Run decompilation
opencode
> /decompile-game-binary RetroGame
> [Answer prompts]

# 3. Check output
ls features/decompiled_source/retro-game/

# 4. Build
cd features/decompiled_source/retro-game/
mkdir build && cd build
cmake .. && make

# 5. Test
./retro-game
```

### Workflow B: Protocol Analysis Only

```bash
# 1. Start in your project directory
cd ~/server-recreation

# 2. Run analysis
opencode
> /analyze-game-protocol ./game-client.exe
> [Follow Ghidra guidance]

# 3. Check output
cat .planning/game-protocol-analysis/*/PROTOCOL.md

# 4. Implement server using spec
# Use SERVER-GUIDE.md for guidance
```

### Workflow C: Full Game Preservation

```bash
# Both decompilation and protocol analysis

# 1. Decompile client
opencode
> /decompile-game-binary GameClient

# 2. Analyze protocol
> /analyze-game-protocol ./original-client.exe

# 3. Now you have:
#    - Compilable source code
#    - Network protocol specification
#    - Everything to recreate the game
```

## Directory Structure After Use

After running the tools, your project will have:

```
your-project/
├── .planning/
│   ├── game-decompilation/
│   │   └── {game-name}/
│   │       ├── PROJECT.md
│   │       └── mcp-sessions/
│   │           └── SESSION-001.md
│   └── game-protocol-analysis/
│       └── {game-name}/
│           ├── PROTOCOL.md
│           └── SERVER-GUIDE.md
├── features/
│   └── decompiled_source/
│       └── {game-name}/
│           ├── CMakeLists.txt
│           ├── README.md
│           ├── include/
│           └── src/
└── docs/
    └── decompilation-findings.md
```

## Key Differences from Full GSD

This standalone extraction is simpler than the full GSD system:

**What's Different:**
- No project initialization required (no `/gsd:new-project`)
- No milestone/phase management
- No model profile configuration
- Direct command execution
- Simpler directory structure

**What's the Same:**
- Full decompilation capabilities
- Same agent expertise
- Same quality output
- All reference documentation

## Tips for Success

### Before Starting

1. **Prepare Binary in Ghidra**
   - Import and analyze completely
   - Note exact project name
   - Keep Ghidra open

2. **Start Ghidra MCP Server**
   - Must be running before decompilation
   - Verify connection works
   - Check server logs for issues

3. **Have Goals Ready**
   - Know what you want to achieve
   - Understand the game type
   - Be specific about output needs

### During Decompilation

1. **Be Patient**
   - Large binaries take time
   - Don't interrupt the agent
   - Monitor progress if needed

2. **Answer Prompts Clearly**
   - Use exact Ghidra project names
   - Be specific about goals
   - Provide context when asked

3. **Review Agent Output**
   - Check generated files
   - Read documentation
   - Note any warnings

### After Completion

1. **Test Build Immediately**
   - Compile the source
   - Fix any build errors
   - Document issues found

2. **Review Documentation**
   - Read decompilation findings
   - Understand architecture
   - Note areas for improvement

3. **Preserve Original**
   - Keep original binary safe
   - Back up generated source
   - Document your process

## Troubleshooting

### "Commands not found"
**Solution:** Restart OpenCode completely, not just reload.

### "Cannot connect to Ghidra MCP"
**Solution:** Start Ghidra MCP server, verify it's running on correct port.

### "Project not found in Ghidra"
**Solution:** Use exact project name, check spelling, verify binary is imported.

### "Source won't compile"
**Solution:** Check for missing dependencies, install required libraries, review errors.

## Getting More Help

1. **Read Documentation**
   - `README.md` - Full overview
   - `INSTALLATION.md` - Setup help
   - `QUICKSTART.md` - Quick guide
   - `references/` - Technical details

2. **Check Examples**
   - `examples/` - Usage examples
   - Reference docs show patterns
   - Learn from complete workflows

3. **Community Support**
   - Discord: https://discord.gg/5JJgD5svVS
   - GitHub: https://github.com/glittercowboy/get-shit-done
   - Issues: Report bugs/ask questions

## Advanced Usage

### Batch Processing

Process multiple games:

```bash
for game in *.exe; do
    echo "Processing $game..."
    opencode --script "/decompile-game-binary $(basename $game .exe)"
done
```

### Custom Output Location

Edit command files to change output directories before installation.

### Integration with CI/CD

Use OpenCode in scripts:

```bash
# In your pipeline
opencode --non-interactive --script "/decompile-game-binary MyGame"
```

## Updates

To update to newer versions:

```bash
# Backup current installation
cp -r ~/.config/opencode/commands ~/backup-commands
cp -r ~/.config/opencode/agents ~/backup-agents

# Install new version
cd standalone-game-decompilation-new
./install.sh

# Test functionality
# If issues, restore from backup
```

## Uninstallation

To remove the tools:

```bash
cd standalone-game-decompilation
./uninstall.sh
```

Or manually:

```bash
rm ~/.config/opencode/commands/decompile-game-binary.md
rm ~/.config/opencode/commands/analyze-game-protocol.md
rm ~/.config/opencode/agents/gsd-game-decompiler.md
rm ~/.config/opencode/agents/gsd-game-protocol-analyzer.md
```

---

**You're all set! Start preserving gaming history! 🎮**

For detailed examples and patterns, check the `references/` directory.
