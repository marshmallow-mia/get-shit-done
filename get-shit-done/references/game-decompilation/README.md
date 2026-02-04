# Game Binary Decompilation Reference

## Overview

This guide provides reference information for decompiling video game binaries to compilable source code using the GSD system with Ghidra and MCP integration.

## Command

Use `/gsd:decompile-game-binary` to start a decompilation project.

```
/gsd:decompile-game-binary path/to/game.exe
```

## Use Cases

### 1. Game Preservation
Preserve legacy games by converting to maintainable source code before the original becomes unreadable or incompatible with modern systems.

### 2. Porting
Port games to new platforms by decompiling to clean C/C++ that can be recompiled for different architectures or operating systems.

### 3. Understanding
Learn from professional game implementations by studying decompiled source code with proper names and documentation.

### 4. Enhancement
Add features or fix bugs in legacy games by working with clean source code instead of hex editing or patching.

## Workflow

```
1. Run /gsd:decompile-game-binary
2. Provide game information
3. Agent analyzes binary with Ghidra
4. Agent decompiles functions systematically
5. Agent renames functions/variables descriptively
6. Agent generates compilable source code
7. Agent documents findings
8. Agent creates build system
9. Source code ready in features/decompiled_source/
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

### Phase 1: Binary Analysis
1. Load binary in Ghidra
2. Run auto-analysis
3. Identify sections (.text, .data, .rdata, .bss)
4. Extract strings for clues
5. Identify imports/dependencies
6. Document initial findings

### Phase 2: System Identification
1. Find graphics API calls (DirectX, OpenGL, Vulkan)
2. Find audio API calls (DirectSound, OpenAL, FMOD)
3. Find input handling (DirectInput, Raw Input)
4. Find networking (if multiplayer)
5. Find physics engine (if used)
6. Document all major subsystems

### Phase 3: Function Decompilation
1. Start with main/WinMain entry point
2. Decompile initialization functions
3. Decompile game loop
4. Decompile update/render functions
5. Decompile system-specific functions
6. Work through call graph systematically

### Phase 4: Naming and Refinement
1. Analyze function purpose from code
2. Rename in Ghidra with descriptive names
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

### 1. Work Systematically
Don't jump around - follow the execution flow from main entry point outward.

### 2. Document As You Go
Write down findings immediately while context is fresh.

### 3. Compile Frequently
Test compilation after each module to catch errors early.

### 4. Use Version Control
Commit progress regularly to track changes.

### 5. Cross-Reference
Use Ghidra's cross-reference features to understand function relationships.

### 6. Test Incrementally
Verify each decompiled system works before moving to the next.

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
