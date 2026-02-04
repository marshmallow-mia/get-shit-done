# Installation Guide

This guide explains how to install the standalone game decompilation tools into OpenCode or other compatible AI coding assistants.

## Table of Contents

- [OpenCode Installation](#opencode-installation)
- [Manual Installation](#manual-installation)
- [Verification](#verification)
- [Uninstallation](#uninstallation)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before installing, ensure you have:

1. **OpenCode** installed and working
   - Or another compatible AI coding assistant that supports custom commands/agents
2. **Node.js** 16.7.0 or later (for OpenCode)
3. **Ghidra** (for decompilation features)
   - Download from https://ghidra-sre.org/
   - Version 10.0 or later recommended

## OpenCode Installation

### Option 1: Automated Installation (Recommended)

Use the installation script for quick setup:

```bash
cd standalone-game-decompilation
chmod +x install.sh
./install.sh
```

The script will:
1. Detect your OpenCode configuration directory
2. Create necessary directories
3. Copy command and agent files
4. Set up proper permissions
5. Verify installation

### Option 2: Manual Installation

If the automated script doesn't work, follow these manual steps:

#### 1. Locate OpenCode Configuration Directory

OpenCode configuration is typically in:
- Linux/macOS: `~/.config/opencode/`
- Windows: `%USERPROFILE%\.config\opencode\`

Or use the OpenCode config directory from environment variable:
```bash
echo $OPENCODE_CONFIG_DIR
```

#### 2. Create Required Directories

```bash
# Linux/macOS
mkdir -p ~/.config/opencode/commands
mkdir -p ~/.config/opencode/agents

# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\commands"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\agents"
```

#### 3. Copy Command Files

```bash
# Linux/macOS
cp commands/*.md ~/.config/opencode/commands/

# Windows (PowerShell)
Copy-Item commands\*.md "$env:USERPROFILE\.config\opencode\commands\"
```

#### 4. Copy Agent Files

```bash
# Linux/macOS
cp agents/*.md ~/.config/opencode/agents/

# Windows (PowerShell)
Copy-Item agents\*.md "$env:USERPROFILE\.config\opencode\agents\"
```

#### 5. Verify File Permissions

```bash
# Linux/macOS - ensure files are readable
chmod 644 ~/.config/opencode/commands/*.md
chmod 644 ~/.config/opencode/agents/*.md
```

### Option 3: Symlink Installation (Development)

For development or if you want to keep files in the extraction directory:

```bash
# Create symlinks instead of copying
ln -s "$(pwd)/commands/"*.md ~/.config/opencode/commands/
ln -s "$(pwd)/agents/"*.md ~/.config/opencode/agents/
```

This allows you to edit the source files and have changes immediately reflected.

## Custom Configuration Directory

If you use a custom OpenCode configuration directory:

```bash
# Set environment variable
export OPENCODE_CONFIG_DIR="/path/to/your/config"

# Then run installation
./install.sh
```

Or manually specify paths:

```bash
CUSTOM_DIR="/path/to/your/config"
mkdir -p "$CUSTOM_DIR/commands" "$CUSTOM_DIR/agents"
cp commands/*.md "$CUSTOM_DIR/commands/"
cp agents/*.md "$CUSTOM_DIR/agents/"
```

## Docker/Container Installations

For containerized environments:

```dockerfile
# In your Dockerfile
FROM your-base-image

# Copy installation files
COPY standalone-game-decompilation /opt/game-decompilation

# Install to OpenCode
RUN mkdir -p /root/.config/opencode/commands /root/.config/opencode/agents && \
    cp /opt/game-decompilation/commands/*.md /root/.config/opencode/commands/ && \
    cp /opt/game-decompilation/agents/*.md /root/.config/opencode/agents/
```

Or in docker-compose:

```yaml
version: '3'
services:
  opencode:
    image: your-opencode-image
    volumes:
      - ./standalone-game-decompilation/commands:/root/.config/opencode/commands
      - ./standalone-game-decompilation/agents:/root/.config/opencode/agents
```

## Other AI Coding Assistants

### Claude Code

These tools can also work with Claude Code (the original target):

```bash
# Copy to Claude Code directory
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents

cp commands/*.md ~/.claude/commands/
cp agents/*.md ~/.claude/agents/
```

### Gemini CLI

For Gemini CLI:

```bash
# Copy to Gemini directory
mkdir -p ~/.gemini/commands
mkdir -p ~/.gemini/agents

cp commands/*.md ~/.gemini/commands/
cp agents/*.md ~/.gemini/agents/
```

### Generic Installation

For other compatible assistants, copy files to their equivalent directories:

```bash
# Replace YOUR_ASSISTANT with the actual directory name
cp commands/*.md ~/.YOUR_ASSISTANT/commands/
cp agents/*.md ~/.YOUR_ASSISTANT/agents/
```

## Verification

After installation, verify everything is working:

### 1. Restart OpenCode

```bash
# Close any running OpenCode instances
pkill opencode

# Start OpenCode
opencode
```

### 2. Check Commands Available

In OpenCode, type:
```
/decompile-game-binary
```

You should see the command autocomplete or execute.

### 3. Test Help

```
/decompile-game-binary --help
```

Should show command information.

### 4. Verify Files

Check that files exist in the correct locations:

```bash
# List installed files
ls -la ~/.config/opencode/commands/
ls -la ~/.config/opencode/agents/

# Should show:
# decompile-game-binary.md
# analyze-game-protocol.md
# gsd-game-decompiler.md
# gsd-game-protocol-analyzer.md
```

## Uninstallation

To remove the tools:

### Automated Uninstallation

```bash
cd standalone-game-decompilation
./uninstall.sh
```

### Manual Uninstallation

```bash
# Remove command files
rm ~/.config/opencode/commands/decompile-game-binary.md
rm ~/.config/opencode/commands/analyze-game-protocol.md

# Remove agent files
rm ~/.config/opencode/agents/gsd-game-decompiler.md
rm ~/.config/opencode/agents/gsd-game-protocol-analyzer.md

# Restart OpenCode
pkill opencode
opencode
```

### Cleaning Up Project Files

If you've used the tools and want to clean up generated files:

```bash
# Remove decompilation output (be careful!)
rm -rf features/decompiled_source/

# Remove planning files
rm -rf .planning/game-decompilation/
rm -rf .planning/game-protocol-analysis/

# Remove documentation
rm -f docs/decompilation-findings.md
```

## Troubleshooting

### Commands Not Showing Up

**Problem:** Commands don't appear in OpenCode after installation.

**Solutions:**
1. Restart OpenCode completely (not just reload)
2. Verify files are in correct directory:
   ```bash
   ls ~/.config/opencode/commands/*.md
   ```
3. Check file permissions (should be readable):
   ```bash
   ls -l ~/.config/opencode/commands/
   ```
4. Verify OpenCode configuration directory:
   ```bash
   # Check OpenCode uses this directory
   opencode --config-dir
   ```

### Permission Denied Errors

**Problem:** Cannot copy files to configuration directory.

**Solutions:**
1. Check directory exists:
   ```bash
   mkdir -p ~/.config/opencode/commands
   mkdir -p ~/.config/opencode/agents
   ```
2. Fix ownership:
   ```bash
   sudo chown -R $USER:$USER ~/.config/opencode/
   ```
3. Use sudo if necessary (not recommended):
   ```bash
   sudo cp commands/*.md ~/.config/opencode/commands/
   ```

### Wrong Configuration Directory

**Problem:** OpenCode uses a different config directory than expected.

**Solutions:**
1. Find actual config directory:
   ```bash
   # Check environment variables
   echo $OPENCODE_CONFIG_DIR
   echo $XDG_CONFIG_HOME
   
   # Or check OpenCode process
   ps aux | grep opencode
   ```
2. Install to correct directory:
   ```bash
   export OPENCODE_CONFIG_DIR="/actual/path"
   ./install.sh
   ```

### Symlinks Not Working

**Problem:** Symlinked files don't work in OpenCode.

**Solutions:**
1. Use hard copies instead of symlinks:
   ```bash
   cp commands/*.md ~/.config/opencode/commands/
   ```
2. Check symlink targets:
   ```bash
   ls -la ~/.config/opencode/commands/
   ```
3. Verify symlink points to correct absolute path

### Installation Script Fails

**Problem:** `install.sh` exits with an error.

**Solutions:**
1. Check script has execute permissions:
   ```bash
   chmod +x install.sh
   ```
2. Run with bash explicitly:
   ```bash
   bash install.sh
   ```
3. Check for error messages and address specific issue
4. Fall back to manual installation

### OpenCode Doesn't Support Commands

**Problem:** Your AI assistant doesn't recognize the command format.

**Solutions:**
1. Check if your assistant supports markdown-based commands
2. Verify the command file format matches your assistant's requirements
3. Consult your assistant's documentation for custom command syntax
4. Consider using the tools through direct agent invocation instead

## Advanced Configuration

### Custom Command Names

To rename commands, edit the `name:` field in command files:

```bash
# Edit command file
nano ~/.config/opencode/commands/decompile-game-binary.md

# Change:
name: decompile-game-binary
# To:
name: my-custom-decompile
```

### Adding to Existing GSD Installation

If you already have full GSD installed and want these as standalone:

```bash
# Create separate directory for standalone version
mkdir -p ~/.config/opencode/commands/standalone
cp commands/*.md ~/.config/opencode/commands/standalone/
```

This keeps them separate from the full GSD system.

### Integration with Other Tools

To integrate with your workflow:

1. **VS Code:** Install OpenCode extension, commands work automatically
2. **Vim/Neovim:** Use OpenCode CLI from editor
3. **Emacs:** Configure to call OpenCode commands
4. **CI/CD:** Use OpenCode in scripts with `--non-interactive` flag

## Getting Help

If you continue to have installation issues:

1. Check the main README.md for troubleshooting
2. Review OpenCode's documentation
3. Join GSD Discord: https://discord.gg/5JJgD5svVS
4. Create issue on GitHub: https://github.com/glittercowboy/get-shit-done/issues

## Next Steps

After successful installation:

1. Review the main [README.md](README.md) for usage examples
2. Read reference documentation in `references/`
3. Set up Ghidra for decompilation work
4. Try a simple decompilation project to test your setup

---

**Installation complete! 🎉**

You're ready to start decompiling game binaries and analyzing protocols.
