---
name: gsd:analyze-game-protocol
description: Reverse engineer video game server protocols using Ghidra and MCP to understand network communication
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
Analyze video game binaries to reverse engineer the server communication protocol using Ghidra and Model Context Protocol (MCP).

**Use case:** Legacy or shut-down game servers where you need to understand the protocol to recreate server functionality.

**Orchestrator role:** Gather game info, set up analysis environment, spawn gsd-game-protocol-analyzer agent, manage analysis sessions, generate protocol documentation.

**Why subagent:** Binary analysis with Ghidra is complex and requires significant context. Fresh context per analysis session ensures thorough investigation without context degradation.
</objective>

<context>
Game binary path or project: $ARGUMENTS

Check for existing analysis sessions:
```bash
ls .planning/game-protocol-analysis/*.md 2>/dev/null | head -5
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
| gsd-game-protocol-analyzer | opus | sonnet | sonnet |

Store resolved model for use in Task calls below.

## 1. Check Existing Sessions

Check if `.planning/game-protocol-analysis/` directory exists:

```bash
ls -la .planning/game-protocol-analysis/ 2>/dev/null
```

If sessions exist AND no $ARGUMENTS:
- List existing analysis projects with status
- User can select one to continue OR start new analysis

If $ARGUMENTS provided OR user starts new:
- Continue to information gathering

## 2. Gather Game Information

Use AskUserQuestion for each (skip if obvious from arguments):

1. **Game Name** - What's the game called?
2. **Binary Location** - Where is the game binary/executable? (full path)
3. **Platform** - What platform? (Windows/Linux/Mac/Console)
4. **Server Status** - Is the server completely shut down? When?
5. **Known Info** - Any existing info about the protocol? (TCP/UDP, port, encryption)
6. **Analysis Goal** - What specifically do you want to know? (connection handshake, message format, authentication, etc.)
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
  - c) Continue with manual analysis guidance

If proceeding without Ghidra:
- Switch to "manual analysis mode" with guidance only

## 4. Create Analysis Directory Structure

```bash
mkdir -p .planning/game-protocol-analysis/{project-slug}
mkdir -p .planning/game-protocol-analysis/{project-slug}/ghidra-projects
mkdir -p .planning/game-protocol-analysis/{project-slug}/findings
mkdir -p .planning/game-protocol-analysis/{project-slug}/protocol-docs
```

Create initial project file:

```markdown
# Game Protocol Analysis: {game-name}

## Project Information
- **Game Name:** {game-name}
- **Binary Path:** {binary-path}
- **Platform:** {platform}
- **Analysis Started:** {timestamp}
- **Status:** In Progress

## Analysis Goals
{goals}

## Known Information
{known-info}

## Analysis Sessions
- Session 1: {timestamp} - Initial analysis

## Findings
(To be populated during analysis)

## Protocol Documentation
(To be generated)
```

Write to: `.planning/game-protocol-analysis/{project-slug}/PROJECT.md`

## 5. Spawn gsd-game-protocol-analyzer Agent

Fill prompt with gathered information:

```markdown
<objective>
Analyze game binary to reverse engineer server communication protocol.

**Project:** {game-name}
**Binary:** {binary-path}
**Platform:** {platform}
</objective>

<analysis_context>
**Server Status:** {server-status}
**Known Protocol Info:** {known-info}
**Analysis Goals:** {goals}

**Ghidra Available:** {ghidra-available}
**Project Directory:** .planning/game-protocol-analysis/{project-slug}/
</analysis_context>

<environment>
**Ghidra Path:** {ghidra-path or "Use system PATH"}
**MCP Integration:** Available for server communication analysis
</environment>

<analysis_approach>
1. Load binary in Ghidra (if available) or provide manual analysis guidance
2. Identify network-related functions (socket operations, send/recv, connect)
3. Analyze data structures used in network communication
4. Reverse engineer packet/message format
5. Document protocol handshake and message types
6. Generate protocol specification
7. Identify any encryption or obfuscation
</analysis_approach>

<output_requirements>
Generate comprehensive protocol documentation including:
- Connection flow (handshake sequence)
- Message format specification
- Data types and structures
- Authentication mechanism
- Encryption details (if any)
- Sample packet captures (if possible)
- Recommendations for server implementation
</output_requirements>

<session_file>
Write findings to: .planning/game-protocol-analysis/{project-slug}/SESSION-001.md
</session_file>
```

Spawn the agent:

```
Task(
  prompt=filled_prompt,
  subagent_type="gsd-game-protocol-analyzer",
  model="{analyzer_model}",
  description="Analyze {game-name} protocol"
)
```

## 6. Handle Agent Return

**If `## PROTOCOL ANALYZED`:**
- Display protocol summary
- Show key findings (connection flow, message format, auth mechanism)
- Offer options:
  - "View full documentation" - show complete protocol docs
  - "Generate server skeleton" - create basic server implementation template
  - "Continue analysis" - dive deeper into specific aspects
  - "Export findings" - save to external format

**If `## ANALYSIS IN PROGRESS`:**
- Present current findings
- Show what's been discovered vs. what remains
- Offer options:
  - "Continue session" - spawn continuation agent
  - "Analyze specific function" - deep dive on particular aspect
  - "Pause and save" - checkpoint current state

**If `## NEED MORE INFORMATION`:**
- Show what information is missing
- Request additional context from user:
  - Network captures (pcap files)
  - Configuration files
  - Debug logs
  - Other game files
- Spawn continuation agent with new information

**If `## ENVIRONMENT ISSUE`:**
- Display the issue (e.g., Ghidra not working, binary format unsupported)
- Provide troubleshooting steps
- Offer alternatives (manual analysis, different tools)

## 7. Generate Final Deliverables

After successful analysis, create:

1. **Protocol Specification** (`.planning/game-protocol-analysis/{project-slug}/PROTOCOL.md`)
   - Complete message format documentation
   - Connection flow diagrams (as text/ASCII art)
   - Data structure definitions

2. **Server Implementation Guide** (`.planning/game-protocol-analysis/{project-slug}/SERVER-GUIDE.md`)
   - How to implement a compatible server
   - Required endpoints/handlers
   - Authentication implementation
   - Sample code snippets

3. **Analysis Summary** (`.planning/game-protocol-analysis/{project-slug}/SUMMARY.md`)
   - What was discovered
   - Confidence level of findings
   - Limitations and unknowns
   - Next steps

4. Update project STATE.md:

```markdown
## Game Protocol Analysis Sessions

| Project | Game | Status | Started | Protocol Docs |
|---------|------|--------|---------|---------------|
| {slug} | {name} | Complete | {date} | [PROTOCOL.md](.planning/game-protocol-analysis/{slug}/PROTOCOL.md) |
```

## 8. Post-Analysis Options

Present user with:

1. **Build Server** - Use /gsd:plan-phase to plan server implementation
2. **Analyze Another Binary** - Start new analysis session
3. **Deep Dive** - Continue analyzing specific protocol aspects
4. **Export** - Export findings to different format (JSON, markdown, etc.)

</process>

<tips>
- **Binary formats:** Ghidra supports many formats (PE, ELF, Mach-O), but some require plugins
- **Obfuscation:** Packed or obfuscated binaries need unpacking first
- **Dynamic analysis:** Consider combining with runtime analysis (debugger, network capture)
- **MCP integration:** Use MCP servers to simulate server responses during analysis
- **Incremental approach:** Start with connection handshake, then build out message types
- **Documentation:** Good protocol docs are crucial for server implementation
</tips>

<success_criteria>
- [ ] Game information gathered
- [ ] Analysis environment verified
- [ ] Project directory structure created
- [ ] gsd-game-protocol-analyzer spawned with context
- [ ] Analysis results processed and documented
- [ ] Protocol specification generated
- [ ] Next steps provided to user
</success_criteria>
