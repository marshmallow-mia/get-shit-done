# Game Protocol Analysis Reference Materials

This directory contains reference materials for the `/gsd:analyze-game-protocol` command, which helps reverse engineer video game server protocols using Ghidra and MCP.

## Overview

When video game servers shut down, the games often become unplayable. By analyzing the game binary, we can reverse engineer the network protocol and recreate compatible servers. This enables:

- Playing legacy games with friends on private servers
- Preserving gaming history
- Understanding game networking architecture
- Learning reverse engineering techniques

## Files in This Directory

### [GHIDRA-MCP-GUIDE.md](GHIDRA-MCP-GUIDE.md)

Complete guide to using Ghidra (NSA's reverse engineering tool) with Model Context Protocol (MCP) for game protocol analysis. Covers:

- Ghidra setup and installation
- Binary analysis workflow
- Finding network functions
- Extracting message formats
- Understanding authentication
- MCP integration for automated documentation

**Use this:** When you're new to Ghidra or reverse engineering.

### [COMMON-PATTERNS.md](COMMON-PATTERNS.md)

Quick reference of common patterns found in game network protocols. Includes:

- Message structure patterns (TLV, JSON, Protobuf, etc.)
- Authentication patterns (password hashing, tokens, challenge-response)
- Connection patterns (TCP, UDP, WebSocket, hybrid)
- State synchronization patterns
- Encryption patterns
- Common message types and data structures

**Use this:** To quickly identify patterns during analysis.

### [EXAMPLE-OUTPUT.md](EXAMPLE-OUTPUT.md)

Complete example showing what the analysis produces for a fictional game "Legacy MMO". Demonstrates:

- Full protocol specification
- Server implementation guide with working code
- Security analysis
- Testing instructions
- Troubleshooting tips

**Use this:** To understand what you'll get from the analysis process.

## Quick Start

1. **Install Ghidra** (optional but recommended)
   ```bash
   # Download from https://ghidra-sre.org/
   # Extract and run
   ```

2. **Run the analysis command**
   ```
   /gsd:analyze-game-protocol ./path/to/game.exe
   ```

3. **Follow the prompts** to provide:
   - Game name and platform
   - Known protocol information
   - Analysis goals

4. **Review the output** in `.planning/game-protocol-analysis/{game}/`:
   - `PROTOCOL.md` - Complete protocol specification
   - `SERVER-GUIDE.md` - Implementation guide with code
   - Session files with analysis details

## Use Cases

### Case 1: Complete Server Shutdown

**Situation:** Game you love shut down years ago, servers are gone.

**Goal:** Recreate server to play with friends.

**Steps:**
1. Analyze game binary to extract protocol
2. Implement compatible server using generated guide
3. Host private server for your group

### Case 2: Custom Server Features

**Situation:** Game still runs but you want custom features official server doesn't support.

**Goal:** Create modded server with custom content.

**Steps:**
1. Analyze protocol to understand communication
2. Implement custom server with additional features
3. Connect game client to your custom server

### Case 3: Game Preservation

**Situation:** Old game in danger of being lost to history.

**Goal:** Document protocol for future preservation.

**Steps:**
1. Analyze and document complete protocol
2. Archive documentation for future use
3. Share with preservation community

### Case 4: Security Research

**Situation:** Researching game network security.

**Goal:** Understand potential vulnerabilities.

**Steps:**
1. Analyze authentication and encryption
2. Identify security issues
3. Document findings responsibly

## Important Notes

### Legal Considerations

- **Reverse engineering may be restricted** in some jurisdictions
- **Check the game's EULA** and local laws before proceeding
- **Use only for personal/educational purposes** unless you have permission
- **Don't distribute proprietary content** (game assets, etc.)
- **Respect intellectual property** while preserving gaming history

### Ethical Guidelines

- ✅ **DO:** Preserve games that are no longer commercially available
- ✅ **DO:** Create private servers for personal use
- ✅ **DO:** Share protocol knowledge for educational purposes
- ❌ **DON'T:** Compete with active commercial servers
- ❌ **DON'T:** Use for cheating or griefing
- ❌ **DON'T:** Distribute copyrighted game files

## Prerequisites

### Required Knowledge

- Basic understanding of networking (TCP/IP, sockets)
- Familiarity with programming (any language)
- Patience and attention to detail

### Recommended Knowledge

- Assembly language basics
- Binary file formats (PE, ELF)
- C/C++ for reading decompiled code
- Network protocol concepts

### Required Tools

- Game binary/executable you want to analyze
- Text editor for reviewing analysis output

### Optional Tools

- **Ghidra** - For advanced binary analysis
- **Wireshark** - For network packet capture (if game still runs)
- **x64dbg** - For dynamic analysis and debugging
- **Python/Node.js/Go** - For implementing servers

## Workflow

1. **Gather Information**
   - Game name, platform, server details
   - Any existing knowledge about the protocol
   - Analysis goals

2. **Initial Analysis**
   - Load binary in Ghidra (if available)
   - Extract strings for protocol hints
   - Identify network functions

3. **Deep Dive**
   - Analyze connection establishment
   - Extract message formats
   - Understand authentication
   - Map data structures

4. **Documentation**
   - Generate protocol specification
   - Create implementation guide
   - Document security considerations

5. **Implementation**
   - Build server using generated guide
   - Test with actual game client
   - Iterate based on testing

## Getting Help

If you get stuck:

1. Check the reference materials in this directory
2. Review the example output to see expected results
3. Use `/gsd:debug` if using GSD workflow
4. Search for similar games (many share protocol patterns)
5. Join reverse engineering communities for advice

## Resources

### Reverse Engineering

- Ghidra: https://ghidra-sre.org/
- Ghidra Cheat Sheet: https://ghidra-sre.org/CheatSheet.html
- Awesome Reverse Engineering: https://github.com/tylerha97/awesome-reversing

### Game Networking

- Gaffer On Games: https://gafferongames.com/
- Valve's Networking Documentation
- Game Networking Resources: https://github.com/MFatihMAR/Game-Networking-Resources

### Protocol Analysis

- Wireshark: https://www.wireshark.org/
- Protocol Analysis Wiki: https://wiki.wireshark.org/

### Communities

- /r/ReverseEngineering on Reddit
- Reverse Engineering Discord servers
- Game preservation communities

## Contributing

Found a new common pattern? Have a better example? Improvements welcome!

1. Document the pattern clearly
2. Include code examples
3. Add to COMMON-PATTERNS.md or create new reference file
4. Submit via the standard GSD contribution process

## License

These reference materials are provided as educational resources. Use responsibly and respect applicable laws and intellectual property rights.

---

**Ready to start?** Run `/gsd:analyze-game-protocol` and bring your favorite old game back to life! 🎮🔍
