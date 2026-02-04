---
name: gsd:decompile-game-binary
description: Automate reverse engineering and decompilation of legacy game binaries using Ghidra MCP server
argument-hint: [project name or ghidra project identifier]
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
  - AskUserQuestion
---

<objective>
Automate the reverse engineering and decompilation of legacy game binaries using the Ghidra MCP server. Produce compilable source code that preserves all original game functionality.

**Use case:** Legacy games already analyzed in Ghidra MCP server where you want to generate clean compilable source code.

**Key assumption:** Binaries are already loaded and analyzed in the Ghidra MCP server. This command connects to the MCP server to access the decompiled code.

**Orchestrator role:** Connect to Ghidra MCP, identify available projects, spawn gsd-game-decompiler agent to access decompiled code via MCP, generate compilable source code and documentation.

**Why subagent:** Binary decompilation with Ghidra MCP is complex and requires significant context. Fresh context per decompilation session ensures thorough analysis without context degradation.
</objective>

<context>
Project name or identifier: $ARGUMENTS

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
- Continue to Ghidra MCP connection

## 2. Connect to Ghidra MCP Server

**The binaries are already analyzed in the Ghidra MCP server. We connect to access them.**

Check if Ghidra MCP server is accessible:

```bash
# Check if MCP server is running
# This assumes the Ghidra MCP server is available via standard MCP protocol
echo "Attempting to connect to Ghidra MCP server..."
```

Use AskUserQuestion to gather:

1. **Project Name** - What do you want to call this decompilation project?
2. **Ghidra Project** - Which Ghidra project in MCP contains the binary? (provide list if possible)
3. **Binary Name** - Which binary within the Ghidra project? 
4. **Game Type** - What type of game? (FPS, RPG, Strategy, etc.)
5. **Decompilation Goal** - What specifically do you want to achieve? (understand logic, port to new platform, add features, etc.)

**Note:** The Ghidra MCP server should already have:
- Binary imported and analyzed
- Functions identified
- Initial decompilation complete

Confirm all information before proceeding.

## 3. Verify MCP Access

Test connection to Ghidra MCP and verify project access:

```bash
# Verify we can access the specified Ghidra project via MCP
# The actual MCP connection will be handled by the agent
echo "Verifying access to Ghidra project via MCP..."
```

If project not accessible via MCP:
- Inform user that the binary needs to be loaded in Ghidra MCP first
- Provide guidance on how to set up Ghidra MCP server
- Offer to create documentation-only mode without MCP access

## 4. Create Decompilation Directory Structure

```bash
mkdir -p .planning/game-decompilation/{project-slug}
mkdir -p .planning/game-decompilation/{project-slug}/mcp-sessions
mkdir -p docs/decompilation-findings
mkdir -p features/decompiled_source/{project-slug}
```

Create initial project file:

```markdown
# Game Decompilation: {game-name}

## Project Information
- **Project Name:** {project-name}
- **Ghidra Project:** {ghidra-project-name}
- **Binary:** {binary-name}
- **Game Type:** {game-type}
- **Decompilation Started:** {timestamp}
- **Status:** In Progress

## Decompilation Goals
{goals}

## Ghidra MCP Access
- **MCP Server:** Connected
- **Project:** {ghidra-project-name}
- **Binary:** {binary-name}
- **Analysis Status:** Pre-analyzed in Ghidra

## Decompilation Sessions
- Session 1: {timestamp} - Initial decompilation from MCP

## Progress
- [ ] MCP connection established
- [ ] Decompiled code retrieved from Ghidra MCP
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
Access decompiled code from Ghidra MCP server and produce clean, compilable source code that preserves all original game functionality.

**Project:** {project-name}
**Ghidra Project:** {ghidra-project-name}
**Binary:** {binary-name}
**Game Type:** {game-type}
</objective>

<decompilation_context>
**Decompilation Goals:** {goals}

**Ghidra MCP Access:** Binary already analyzed in Ghidra MCP server
**MCP Project:** {ghidra-project-name}
**Binary Name:** {binary-name}
**Project Directory:** .planning/game-decompilation/{project-slug}/
**Output Directory:** features/decompiled_source/{project-slug}/
**Documentation Directory:** docs/decompilation-findings.md
</decompilation_context>

<environment>
**Ghidra MCP Server:** Available and connected
**MCP Project:** {ghidra-project-name}
**Binary Status:** Pre-analyzed (functions identified, initial decompilation complete)
</environment>

<decompilation_approach>
1. Connect to Ghidra MCP server
2. Access the specified Ghidra project and binary
3. Retrieve decompiled functions from MCP
4. Identify function purposes from decompiled code
5. Rename functions and variables to descriptive names
6. Update names in Ghidra via MCP if possible
7. Generate clean C/C++ source code organized into modules
8. Document significant findings as you go
9. Ensure generated source is compilable
10. Preserve all original game functionality
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
Write findings to: .planning/game-decompilation/{project-slug}/mcp-sessions/SESSION-001.md
</session_file>
```

Spawn the agent:

```
Task(
  prompt=filled_prompt,
  subagent_type="gsd-game-decompiler",
  model="{decompiler_model}",
  description="Decompile {project-name} from Ghidra MCP"
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
  - Ghidra project details
  - MCP connection information
  - Additional analysis needed in Ghidra
- Spawn continuation agent with new information

**If `## ENVIRONMENT ISSUE`:**
- Display the issue (e.g., MCP not accessible, project not found in Ghidra)
- Provide troubleshooting steps:
  - Verify Ghidra MCP server is running
  - Check project name in Ghidra
  - Verify binary is imported and analyzed
- Offer alternatives (manual decompilation guidance)

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

| Project | Game | Ghidra Project | Status | Started | Source Code | Docs |
|---------|------|----------------|--------|---------|-------------|------|
| {slug} | {name} | {ghidra-project} | Complete | {date} | [Source](features/decompiled_source/{slug}/) | [Docs](docs/decompilation-findings.md) |
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
- **Ghidra MCP:** Binaries must be pre-analyzed in Ghidra MCP server before decompilation
- **MCP Connection:** Verify MCP server is accessible before starting
- **Project Names:** Get exact Ghidra project names from the MCP server
- **Incremental approach:** Start with main game loop, then branch out to subsystems
- **Name conventions:** Use descriptive names that explain purpose, not just structure
- **MCP integration:** Use MCP to retrieve decompiled functions efficiently
- **Compilation:** Test compilation frequently to catch type errors early
- **Documentation:** Document as you decompile - context is fresh
</tips>

<success_criteria>
- [ ] Game information gathered
- [ ] Ghidra MCP connection verified
- [ ] Ghidra project and binary identified
- [ ] Project directory structure created
- [ ] gsd-game-decompiler spawned with MCP context
- [ ] Decompilation results processed
- [ ] Clean source code generated in features/decompiled_source/
- [ ] Documentation created in docs/decompilation-findings.md
- [ ] Build system configured
- [ ] Source compiles successfully
- [ ] All original functionality preserved
- [ ] Next steps provided to user
</success_criteria>
