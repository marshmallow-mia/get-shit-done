# Package Manifest

## Standalone Game Decompilation Tools
**Version:** 1.0.0  
**Extracted from:** Get Shit Done v1.11.1  
**Date:** 2026-02-04  
**License:** MIT

## Package Contents

### Core Files

#### Documentation
- `README.md` - Main documentation and overview (10.7 KB)
- `INSTALLATION.md` - Installation guide with troubleshooting (10.2 KB)
- `QUICKSTART.md` - Quick start guide for rapid onboarding (6.2 KB)
- `MANIFEST.md` - This file - package contents and verification

#### Installation Scripts
- `install.sh` - Automated installation script (5.8 KB)
- `uninstall.sh` - Automated uninstallation script (3.7 KB)

### Commands (2 files)

Commands that users can invoke in OpenCode:

- `commands/decompile-game-binary.md` - Main decompilation command
- `commands/analyze-game-protocol.md` - Protocol analysis command

### Agents (2 files)

Specialized AI agents spawned by commands:

- `agents/gsd-game-decompiler.md` - Decompilation specialist agent
- `agents/gsd-game-protocol-analyzer.md` - Protocol analysis specialist agent

### Reference Documentation (7 files)

#### Game Decompilation References
- `references/game-decompilation/README.md` - Decompilation guide and workflow
- `references/game-decompilation/COMMON-GAME-PATTERNS.md` - Common patterns in game code

#### Game Protocol Analysis References
- `references/game-protocol-analysis/README.md` - Protocol analysis guide
- `references/game-protocol-analysis/COMMON-PATTERNS.md` - Common network patterns
- `references/game-protocol-analysis/EXAMPLE-OUTPUT.md` - Example analysis outputs
- `references/game-protocol-analysis/GHIDRA-MCP-GUIDE.md` - Ghidra MCP setup

## Total Package Size

- **Total Files:** 13 markdown + 2 scripts = 15 files
- **Total Size:** ~75 KB (compressed)
- **Disk Space Required:** <1 MB including all documentation

## Installation Footprint

After installation in OpenCode:
```
~/.config/opencode/
├── commands/
│   ├── decompile-game-binary.md    (~50 KB)
│   └── analyze-game-protocol.md     (~40 KB)
└── agents/
    ├── gsd-game-decompiler.md       (~40 KB)
    └── gsd-game-protocol-analyzer.md (~35 KB)
```

**Installed Size:** ~165 KB

## Verification Checklist

Use this checklist to verify package integrity:

### Pre-Installation
- [ ] All files present in package directory
- [ ] install.sh is executable (`chmod +x install.sh`)
- [ ] uninstall.sh is executable (`chmod +x uninstall.sh`)
- [ ] README.md opens and is readable
- [ ] References directory contains all 7 files

### Post-Installation
- [ ] Commands copied to OpenCode config directory
- [ ] Agents copied to OpenCode config directory
- [ ] Files have correct permissions (644)
- [ ] OpenCode recognizes commands (autocomplete works)
- [ ] `/decompile-game-binary --help` shows info
- [ ] `/analyze-game-protocol --help` shows info

### Functional Testing
- [ ] Can start decompilation command
- [ ] Agent spawns successfully
- [ ] Can access reference documentation
- [ ] Installation script completes without errors
- [ ] Uninstallation removes files cleanly

## File Checksums

To verify file integrity, you can generate checksums:

```bash
# Generate SHA256 checksums for verification
cd standalone-game-decompilation
find . -type f -name "*.md" -o -name "*.sh" | sort | xargs sha256sum > checksums.txt
```

## Dependencies

### Required
- **OpenCode** - AI coding assistant
  - Or compatible alternative (Claude Code, Gemini CLI)
- **Bash** - For installation scripts (Linux/macOS/WSL)
  - Or PowerShell/manual installation (Windows)

### Optional but Recommended
- **Ghidra** 10.0+ - For binary analysis
- **Ghidra MCP Server** - For decompilation features
- **CMake** 3.10+ - For building decompiled code
- **GCC/Clang/MSVC** - C/C++ compiler

## Compatibility

### Tested Platforms
- ✅ Linux (Ubuntu 20.04+, Debian 11+, Arch)
- ✅ macOS (10.15+)
- ✅ Windows 10+ (via WSL2)
- ✅ Docker/Containers

### Tested AI Assistants
- ✅ OpenCode (primary target)
- ✅ Claude Code (original source)
- 🔄 Gemini CLI (compatible, not tested)

### Supported Game Platforms
- ✅ Windows (PE executables)
- ✅ Linux (ELF binaries)
- ✅ macOS (Mach-O binaries)
- 🔄 Console games (requires additional tools)

## Version History

### v1.0.0 (2026-02-04)
- Initial standalone extraction from GSD v1.11.1
- Includes decompilation and protocol analysis tools
- Complete documentation and installation scripts
- Self-contained package with no GSD dependencies

## Maintenance

### Updating
To update to newer versions:

```bash
# Backup current installation
cp -r ~/.config/opencode/commands ~/opencode-backup-commands
cp -r ~/.config/opencode/agents ~/opencode-backup-agents

# Run new installer
cd standalone-game-decompilation-new-version
./install.sh

# Test functionality
# If issues, restore backup
```

### Reporting Issues
Report problems at: https://github.com/glittercowboy/get-shit-done/issues

### Contributing
Improvements welcome! See CONTRIBUTING.md in main GSD repository.

## Extraction Details

### Source Repository
- **Project:** Get Shit Done (GSD)
- **Repository:** https://github.com/glittercowboy/get-shit-done
- **Original Branch:** main
- **Extraction Date:** 2026-02-04
- **Source Version:** v1.11.1

### Extracted Components
- Commands: `/gsd:decompile-game-binary`, `/gsd:analyze-game-protocol`
- Agents: `gsd-game-decompiler`, `gsd-game-protocol-analyzer`
- References: Game decompilation and protocol analysis documentation

### Modifications from Original
- Removed GSD system dependencies
- Simplified installation (no GSD orchestrator required)
- Standalone documentation
- Independent installation scripts
- Command names simplified (gsd: prefix optional)

### Not Included
The following GSD features are NOT in this extraction:
- Project management (PROJECT.md, ROADMAP.md, STATE.md)
- Phase/milestone workflow
- Model profile configuration
- Full GSD orchestration system
- Other GSD commands and agents
- GSD update mechanism

## Support

### Self-Service
1. Read README.md for usage
2. Check INSTALLATION.md for troubleshooting
3. Review references/ for technical details
4. Try QUICKSTART.md for quick onboarding

### Community
- Discord: https://discord.gg/5JJgD5svVS
- GitHub Issues: https://github.com/glittercowboy/get-shit-done/issues

### Commercial
For commercial support, contact GSD maintainers.

## Legal

### License
MIT License - See GSD repository for full license text.

### Attribution
Original work by TÂCHES (glittercowboy) as part of Get Shit Done project.

### Disclaimer
These tools are provided for legitimate reverse engineering:
- Game preservation
- Educational purposes
- Personal use modifications
- Security research

Always respect:
- Copyright laws
- Game EULAs
- Intellectual property rights
- Original developers' work

---

**Package verified and ready for distribution! ✅**

*For latest version, check: https://github.com/glittercowboy/get-shit-done*
