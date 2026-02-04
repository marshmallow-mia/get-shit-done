---
name: gsd:decompile-game-binary
description: Automate reverse engineering and decompilation of legacy game binaries using Ghidra and MCP
argument-hint: [game binary path or project name]
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
  - AskUserQuestion
---

<objective>
Automate the reverse engineering and decompilation of legacy game binaries using Ghidra and Model Context Protocol (MCP). Produce compilable source code that preserves all original game functionality.

**Use case:** Legacy games where you want to understand the implementation, maintain the codebase, or port to modern platforms.

**Orchestrator role:** Gather game info, set up decompilation environment, spawn gsd-game-decompiler agent, manage decompilation sessions, generate compilable source code and documentation.

**Why subagent:** Binary decompilation with Ghidra is complex and requires significant context. Fresh context per decompilation session ensures thorough analysis without context degradation.
</objective>

<context>
Game binary path or project: $ARGUMENTS

Check for existing decompilation sessions:
```bash
ls .planning/game-decompilation/*.md 2>/dev/null | head -5
```
</context>

<process>

## 0. Resolve Model Profile

Read model profile for agent spawning:

```bash
MODEL_PROFILE=$(cat .planning/config.json 2>/dev/null | grep -o '"model_profile"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"' || echo "balanced")
```

Default to "balanced" if not set.

**Model lookup table:**

| Agent | quality | balanced | budget |
|-------|---------|----------|--------|
| gsd-game-decompiler | opus | sonnet | sonnet |

Store resolved model for use in Task calls below.

## 1. Check Existing Sessions

Check if `.planning/game-decompilation/` directory exists:

```bash
ls -la .planning/game-decompilation/ 2>/dev/null
```

If sessions exist AND no $ARGUMENTS:
- List existing decompilation projects with status
- User can select one to continue OR start new decompilation

If $ARGUMENTS provided OR user starts new:
- Continue to information gathering

## 2. Gather Game Information

Use AskUserQuestion for each (skip if obvious from arguments):

1. **Game Name** - What's the game called?
2. **Binary Location** - Where is the game binary/executable? (full path)
3. **Platform** - What platform? (Windows/Linux/Mac/Console)
4. **Game Type** - What type of game? (FPS, RPG, Strategy, etc.)
5. **Known Info** - Any existing info about the game? (engine, language, build tools)
6. **Decompilation Goal** - What specifically do you want to achieve? (understand logic, port to new platform, add features, etc.)
7. **Environment Setup** - Do you have Ghidra installed? (yes/no)

Confirm all information before proceeding.

## 3. Environment Setup Verification

Check if Ghidra is available:

```bash
which ghidra 2>/dev/null || echo "Ghidra not found in PATH"
```

If Ghidra not found:
- Inform user about Ghidra installation requirements
- Provide download link: https://ghidra-sre.org/
- Ask if they want to:
  - a) Install Ghidra now (provide instructions)
  - b) Specify custom Ghidra path
  - c) Continue with manual decompilation guidance

If proceeding without Ghidra:
- Switch to "manual decompilation mode" with guidance only

## 4. Create Decompilation Directory Structure

```bash
mkdir -p .planning/game-decompilation/{project-slug}
mkdir -p .planning/game-decompilation/{project-slug}/ghidra-projects
mkdir -p .planning/game-decompilation/{project-slug}/sessions
mkdir -p docs/decompilation-findings
mkdir -p features/decompiled_source/{project-slug}
```

Create initial project file:

```markdown
# Game Decompilation: {game-name}

## Project Information
- **Game Name:** {game-name}
- **Binary Path:** {binary-path}
- **Platform:** {platform}
- **Game Type:** {game-type}
- **Decompilation Started:** {timestamp}
- **Status:** In Progress

## Decompilation Goals
{goals}

## Known Information
{known-info}

## Decompilation Sessions
- Session 1: {timestamp} - Initial decompilation

## Progress
- [ ] Binary analysis complete
- [ ] Function identification complete
- [ ] Variable renaming in progress
- [ ] Documentation in progress
- [ ] Compilable source generated

## Key Findings
(To be populated during decompilation)
```

Write to: `.planning/game-decompilation/{project-slug}/PROJECT.md`

## 5. Spawn gsd-game-decompiler Agent

Fill prompt with gathered information:

```markdown
<objective>
Decompile game binary to produce clean, compilable source code that preserves all original game functionality.

**Project:** {game-name}
**Binary:** {binary-path}
**Platform:** {platform}
**Game Type:** {game-type}
</objective>

<decompilation_context>
**Known Info:** {known-info}
**Decompilation Goals:** {goals}

**Ghidra Available:** {ghidra-available}
**Project Directory:** .planning/game-decompilation/{project-slug}/
**Output Directory:** features/decompiled_source/{project-slug}/
**Documentation Directory:** docs/decompilation-findings.md
</decompilation_context>

<environment>
**Ghidra Path:** {ghidra-path or "Use system PATH"}
**MCP Integration:** Available for code analysis and generation
</environment>

<decompilation_approach>
1. Load binary in Ghidra (if available) or provide manual decompilation guidance
2. Analyze binary structure and identify main components
3. Decompile functions and identify their purpose
4. Rename functions and variables to descriptive names
5. Update names in Ghidra for reference
6. Generate clean C/C++ source code
7. Document significant findings as you go
8. Ensure generated source is compilable
9. Preserve all original game functionality
</decompilation_approach>

<output_requirements>
Generate comprehensive decompilation output including:
- Clean, compilable source code in features/decompiled_source/{project-slug}/
- Descriptive function and variable names
- Documentation of significant findings in docs/decompilation-findings.md
- Header files with proper structure definitions
- Build system configuration (Makefile, CMakeLists.txt, etc.)
- README with build instructions
- Comments explaining complex logic
</output_requirements>

<session_file>
Write findings to: .planning/game-decompilation/{project-slug}/sessions/SESSION-001.md
</session_file>
```

Spawn the agent:

```
Task(
  prompt=filled_prompt,
  subagent_type="gsd-game-decompiler",
  model="{decompiler_model}",
  description="Decompile {game-name}"
)
```

## 6. Handle Agent Return

**If `## DECOMPILATION COMPLETE`:**
- Display decompilation summary
- Show key findings (architecture, main systems, dependencies)
- Show generated files count and structure
- Offer options:
  - "View documentation" - show decompilation findings
  - "Build source" - compile the generated source
  - "Continue decompiling" - work on specific modules
  - "Export project" - package for external use

**If `## DECOMPILATION IN PROGRESS`:**
- Present current progress
- Show what's been decompiled vs. what remains
- Offer options:
  - "Continue session" - spawn continuation agent
  - "Focus on module" - deep dive on particular component
  - "Pause and save" - checkpoint current state

**If `## NEED MORE INFORMATION`:**
- Show what information is missing
- Request additional context from user:
  - Additional game files (DLLs, assets, configs)
  - Debug symbols (if available)
  - Original documentation
  - Source code snippets (if any exist)
- Spawn continuation agent with new information

**If `## ENVIRONMENT ISSUE`:**
- Display the issue (e.g., Ghidra not working, binary format unsupported)
- Provide troubleshooting steps
- Offer alternatives (manual decompilation, different tools)

## 7. Generate Final Deliverables

After successful decompilation, verify:

1. **Source Code** (`features/decompiled_source/{project-slug}/`)
   - Organized directory structure
   - Proper header files (.h)
   - Implementation files (.c/.cpp)
   - Well-named functions and variables
   - Inline comments for complex logic

2. **Documentation** (`docs/decompilation-findings.md`)
   - Architecture overview
   - System descriptions
   - Data structure definitions
   - Notable algorithms or patterns
   - Challenges encountered
   - Areas needing further work

3. **Build System** (`features/decompiled_source/{project-slug}/`)
   - CMakeLists.txt or Makefile
   - Build configuration
   - Dependency list
   - README with build instructions

4. **Compilation Test**
   ```bash
   cd features/decompiled_source/{project-slug}
   mkdir build && cd build
   cmake .. && make
   # Or: make clean && make
   ```

5. Update project STATE.md:

```markdown
## Game Decompilation Sessions

| Project | Game | Status | Started | Source Code | Docs |
|---------|------|--------|---------|-------------|------|
| {slug} | {name} | Complete | {date} | [Source](features/decompiled_source/{slug}/) | [Docs](docs/decompilation-findings.md) |
```

## 8. Post-Decompilation Options

Present user with:

1. **Test Build** - Compile and test the generated source
2. **Enhance Code** - Add features or improvements
3. **Port to Platform** - Adapt for different OS/architecture
4. **Decompile More** - Start new decompilation session
5. **Document Further** - Deep dive into specific systems

</process>

<tips>
- **Binary formats:** Ghidra supports many formats (PE, ELF, Mach-O), but some require plugins
- **Obfuscation:** Packed or obfuscated binaries need unpacking first
- **Incremental approach:** Start with main game loop, then branch out to subsystems
- **Name conventions:** Use descriptive names that explain purpose, not just structure
- **MCP integration:** Use MCP for understanding code patterns and generating clean output
- **Compilation:** Test compilation frequently to catch type errors early
- **Documentation:** Document as you decompile - context is fresh
</tips>

<success_criteria>
- [ ] Game information gathered
- [ ] Decompilation environment verified
- [ ] Project directory structure created
- [ ] gsd-game-decompiler spawned with context
- [ ] Decompilation results processed
- [ ] Clean source code generated in features/decompiled_source/
- [ ] Documentation created in docs/decompilation-findings.md
- [ ] Build system configured
- [ ] Source compiles successfully
- [ ] All original functionality preserved
- [ ] Next steps provided to user
</success_criteria>
