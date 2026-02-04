# Game Binary Decompilation Reference

## Overview

This guide provides reference information for accessing decompiled code from Ghidra MCP servers and generating compilable source code using the GSD system.

## Command

Use `/gsd:decompile-game-binary` to start a decompilation project.

```
/gsd:decompile-game-binary RetroGame
```

**Prerequisites:** Binary must already be loaded and analyzed in a running Ghidra MCP server.

## Use Cases

### 1. Game Preservation
Preserve legacy games by converting pre-analyzed Ghidra code to maintainable source code before the original becomes unreadable or incompatible with modern systems.

### 2. Porting
Port games to new platforms by accessing decompiled code from Ghidra MCP and organizing it into clean C/C++ that can be recompiled for different architectures or operating systems.

### 3. Understanding
Learn from professional game implementations by studying decompiled source code retrieved from Ghidra MCP with proper names and documentation.

### 4. Enhancement
Add features or fix bugs in legacy games by working with clean source code generated from Ghidra MCP analysis.

## Workflow

```
1. Binary analyzed in Ghidra MCP server (prerequisite)
2. Run /gsd:decompile-game-binary
3. Connect to Ghidra MCP server
4. Specify Ghidra project and binary
5. Agent retrieves decompiled functions via MCP
6. Agent organizes code into modules
7. Agent renames functions/variables descriptively
8. Agent generates compilable source code
9. Agent documents findings
10. Agent creates build system
11. Source code ready in features/decompiled_source/
```

## Output Structure

```
features/decompiled_source/{game-slug}/
├── include/              # Header files
│   ├── types.h          # Data structures
│   ├── game.h           # Game logic API
│   ├── renderer.h       # Rendering API
│   ├── audio.h          # Audio API
│   └── input.h          # Input API
├── src/                 # Source files
│   ├── main.c           # Entry point
│   ├── game.c           # Core game logic
│   ├── rendering/       # Rendering system
│   ├── audio/           # Audio system
│   ├── input/           # Input system
│   └── physics/         # Physics system
├── assets/              # Game assets (if extracted)
├── tests/               # Test cases
├── CMakeLists.txt       # Build configuration
├── Makefile             # Alternative build system
└── README.md            # Build instructions

docs/decompilation-findings.md  # Comprehensive documentation

.planning/game-decompilation/{game-slug}/
├── PROJECT.md           # Project information
├── ghidra-projects/     # Ghidra project files
└── sessions/            # Decompilation session logs
```

## Decompilation Process

### Phase 1: Ghidra MCP Connection
1. Verify Ghidra MCP server is running
2. Connect to MCP server
3. List available Ghidra projects
4. Select project and binary
5. Verify binary is analyzed
6. Document connection details

### Phase 2: Retrieve Decompiled Code
1. Get function list from Ghidra via MCP
2. Retrieve decompiled code for each function
3. Access data structures from Ghidra
4. Get symbol information
5. Retrieve cross-reference data

### Phase 3: Function Organization
1. Categorize functions by subsystem
2. Identify main entry point
3. Identify initialization functions
4. Identify game loop
5. Group related functions

### Phase 4: Naming and Refinement
1. Analyze function purpose from decompiled code
2. Create descriptive function names
3. Identify and name data structures
4. Add type information
5. Document complex algorithms

### Phase 5: Source Generation
1. Generate clean C/C++ source files
2. Organize into logical modules
3. Create header files
4. Add comments for clarity
5. Ensure code compiles

### Phase 6: Documentation
1. Document architecture overview
2. Describe each major system
3. Document data structures
4. Note algorithms and patterns
5. Record challenges and solutions

### Phase 7: Build System
1. Create CMakeLists.txt or Makefile
2. Configure for target platform(s)
3. List dependencies
4. Create README with build instructions
5. Test compilation

## Best Practices

### 1. Verify MCP Connection
Ensure Ghidra MCP server is running and accessible before starting.

### 2. Check Binary Analysis
Verify the binary is fully analyzed in Ghidra before retrieving decompiled code.

### 3. Work Systematically
Retrieve function list first, then process functions in logical order (entry point → initialization → game loop → subsystems).

### 4. Document As You Go
Write down findings immediately while context is fresh from MCP retrieval.

### 5. Compile Frequently
Test compilation after each module to catch errors early.

### 6. Use MCP Efficiently
Batch retrieve related functions to minimize MCP round-trips.

### 7. Preserve Behavior
Ensure all original functionality is maintained - don't "improve" game logic.

## Related Commands

- `/gsd:analyze-game-protocol` - For reverse engineering network protocols
- `/gsd:map-codebase` - For analyzing existing source code
- `/gsd:plan-phase` - For planning implementation of features based on decompiled code

## Resources

### Ghidra Resources
- Official Documentation: https://ghidra-sre.org/
- Ghidra GitHub: https://github.com/NationalSecurityAgency/ghidra
- Awesome Ghidra: https://github.com/AllsafeCyberSecurity/awesome-ghidra

Happy decompiling! 🎮🔍
