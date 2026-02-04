# Decompiled Source Directory

This directory contains compilable source code generated from game binary decompilation.

## Purpose

When using `/gsd:decompile-game-binary`, the generated source code will be organized in subdirectories here, one per game project.

## Structure

Each decompiled game project will have a structure like:

```
{game-slug}/
├── include/              # Header files
│   ├── types.h          # Data structure definitions
│   ├── game.h           # Core game API
│   ├── renderer.h       # Rendering system API
│   ├── audio.h          # Audio system API
│   └── input.h          # Input system API
├── src/                 # Source files
│   ├── main.c           # Main entry point
│   ├── game.c           # Core game logic
│   ├── rendering/       # Rendering system implementation
│   ├── audio/           # Audio system implementation
│   ├── input/           # Input system implementation
│   └── physics/         # Physics system implementation
├── assets/              # Game assets (if extracted)
├── tests/               # Test cases
├── CMakeLists.txt       # CMake build configuration
├── Makefile             # Alternative Makefile build
└── README.md            # Build instructions and project info
```

## Building

Each project contains its own build instructions in its README.md file. Generally:

### Using CMake:
```bash
cd {game-slug}
mkdir build && cd build
cmake ..
make
```

### Using Make:
```bash
cd {game-slug}
make
```

## Contributing

If you improve or enhance any decompiled code, please document your changes and ensure the code still compiles and maintains original functionality.

---

<!-- Project directories will be created here during decompilation -->
