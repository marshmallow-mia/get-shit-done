# Game Protocol Analysis - Ghidra & MCP Integration Guide

## Overview

This guide explains how to use Ghidra with Model Context Protocol (MCP) to reverse engineer video game server protocols. This is particularly useful for games with shut-down servers where you want to recreate server functionality.

## Prerequisites

### Required Tools

1. **Ghidra** - NSA's reverse engineering framework
   - Download: https://ghidra-sre.org/
   - Version: 10.4+ recommended
   - Java 17+ required

2. **Game Binary** - The executable you want to analyze
   - Windows: `.exe` files
   - Linux: ELF binaries
   - Mac: Mach-O binaries

3. **Optional but Helpful:**
   - Wireshark - Network protocol analyzer
   - x64dbg / IDA Pro - Dynamic analysis tools
   - Network packet captures (if game still runs)

### Knowledge Prerequisites

- Basic understanding of assembly language
- Familiarity with networking concepts (TCP/IP, sockets)
- Understanding of binary file formats
- Basic C/C++ for reading decompiled code

## Ghidra Setup

### Installation

```bash
# Download from https://ghidra-sre.org/
# Extract the archive
unzip ghidra_10.4_PUBLIC_*.zip
cd ghidra_10.4_PUBLIC

# Run Ghidra
./ghidraRun
```

### Creating a Project

1. Launch Ghidra
2. File → New Project → Non-Shared Project
3. Choose project directory (e.g., `.planning/game-protocol-analysis/{project}/ghidra-projects`)
4. Name your project (e.g., "GameProtocolAnalysis")

### Importing the Binary

1. File → Import File
2. Select your game executable
3. Ghidra will auto-detect format (PE, ELF, Mach-O)
4. Click OK to import with default settings
5. When prompted, run Auto Analysis (click "Yes")
   - This may take several minutes for large binaries

## MCP (Model Context Protocol) Integration

### What is MCP?

MCP provides a standardized way for AI models to interact with external data sources and tools. In game protocol analysis, MCP can help:

1. **Automate pattern recognition** - Identify common network protocol patterns
2. **Generate documentation** - Create protocol specs from findings
3. **Suggest implementations** - Propose server code based on protocol
4. **Cross-reference knowledge** - Compare with known protocols

### Using MCP with Ghidra

MCP can be integrated at different stages:

#### 1. Initial Analysis Phase

Use MCP to:
- Analyze string outputs from the binary
- Identify potential server endpoints
- Recognize common networking APIs
- Suggest areas to investigate

```bash
# Extract strings and analyze with MCP-enabled tools
strings game.exe > game_strings.txt
# Process through MCP for pattern recognition
```

#### 2. Function Analysis Phase

Use MCP to:
- Understand decompiled code from Ghidra
- Identify data structures
- Recognize protocol patterns
- Generate structure definitions

#### 3. Documentation Phase

Use MCP to:
- Generate protocol specifications
- Create implementation guides
- Write test cases
- Suggest security considerations

## Reverse Engineering Workflow

### Phase 1: Initial Reconnaissance

#### 1.1 Examine Strings

In Ghidra's CodeBrowser:
1. Window → Defined Strings
2. Look for patterns:
   - Server URLs/IPs: "server.game.com", "192.168.1.1"
   - Ports: "8080", "27015"
   - Protocol keywords: "connect", "login", "auth", "session"
   - Error messages: "Connection failed", "Invalid token"
   - Message types: "PLAYER_UPDATE", "CHAT_MESSAGE"

**Export findings:**
```
Search → For Strings → Export to CSV
```

#### 1.2 Identify Imports

Check which networking libraries are used:

1. Window → Symbol Tree
2. Expand "Imports"
3. Look for:

**Windows (ws2_32.dll):**
- WSAStartup / WSACleanup
- socket, connect, send, recv
- closesocket, shutdown
- inet_addr, htons, ntohs

**Cross-platform:**
- OpenSSL (SSL_connect, SSL_write, SSL_read)
- cURL (curl_easy_init, curl_easy_perform)
- ZeroMQ (zmq_connect, zmq_send)
- Protobuf (google::protobuf::*)

### Phase 2: Find Network Functions

#### 2.1 Search for Socket Creation

1. Search → For Functions
2. Search for: "socket", "WSASocket"
3. Double-click found functions to navigate

#### 2.2 Analyze Connection Logic

Find the function that establishes server connection:

```c
// Example decompiled code in Ghidra
int connect_to_server(void) {
    SOCKET sock;
    sockaddr_in server_addr;
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(7777);  // Port identified!
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    connect(sock, (sockaddr*)&server_addr, 16);
    return sock;
}
```

**Document findings:**
- Protocol: TCP (SOCK_STREAM) or UDP (SOCK_DGRAM)
- Port: 7777 in above example
- Server address handling

#### 2.3 Find Send/Recv Calls

1. Navigate to functions that use the socket
2. Look for calls to send(), recv(), sendto(), recvfrom()
3. Analyze what data is being sent

**Cross-reference:**
- Right-click on function → References → Show References to
- This shows everywhere the function is called

## Complete workflow continues with message format analysis, authentication analysis, etc.

For the full guide, see the complete documentation.

## Resources

### Official Documentation

- Ghidra: https://ghidra-sre.org/
- Ghidra GitHub: https://github.com/NationalSecurityAgency/ghidra

### Community Resources

- Ghidra Scripts: https://github.com/AllsafeCyberSecurity/awesome-ghidra
- Reverse Engineering communities

Happy reverse engineering! 🎮🔍
