# Common Game Protocol Patterns

## Overview

This reference guide documents common patterns found in video game network protocols. Use this to quickly identify and understand protocols during reverse engineering.

## Message Structure Patterns

### Pattern 1: Fixed Header + Variable Payload

Most common in game protocols.

```c
struct Message {
    uint16_t type;        // Message type ID
    uint32_t length;      // Payload length
    uint8_t payload[];    // Variable length data
};
```

**Examples:**
- Source Engine games
- Many MMORPGs
- Custom game servers

### Pattern 2: Type-Length-Value (TLV)

Common in extensible protocols.

```c
struct TLVMessage {
    uint8_t type;
    uint16_t length;
    uint8_t value[length];
};
```

**Examples:**
- Network protocols
- Configuration systems

### Pattern 3: JSON over TCP/WebSocket

Modern games often use JSON.

```json
{
  "type": "player_move",
  "data": {
    "x": 100.5,
    "y": 250.0,
    "z": 10.0
  }
}
```

**Examples:**
- Web-based games
- Mobile games
- Modern indie games

### Pattern 4: Protobuf

Efficient binary serialization.

```protobuf
message PlayerMove {
  float x = 1;
  float y = 2;
  float z = 3;
}
```

**Examples:**
- Google games
- Performance-critical games
- Modern multiplayer games

## Authentication Patterns

### Pattern 1: Username + Password Hash

```c
struct LoginRequest {
    char username[32];
    char password_hash[64];  // SHA256, MD5, etc.
};
```

### Pattern 2: Token-Based Authentication

```c
struct LoginRequest {
    char username[32];
    char password_hash[64];
};

struct LoginResponse {
    uint8_t success;
    char session_token[128];
    uint32_t expiry;
};

// All subsequent messages include token
struct GameMessage {
    char session_token[128];
    // ... message data
};
```

### Pattern 3: Challenge-Response

```c
// 1. Client requests challenge
struct ChallengeRequest {
    char username[32];
};

// 2. Server sends challenge
struct ChallengeResponse {
    uint8_t challenge[32];  // Random bytes
};

// 3. Client responds with solution
struct AuthRequest {
    uint8_t solution[32];  // HMAC(password, challenge)
};
```

## Connection Patterns

### Pattern 1: Direct TCP Connection

```
Client -> Server: Connect to port 7777
Client -> Server: LOGIN
Server -> Client: LOGIN_SUCCESS
Client <-> Server: Game messages
```

### Pattern 2: WebSocket Connection

```
Client -> Server: HTTP Upgrade request
Server -> Client: 101 Switching Protocols
Client <-> Server: WebSocket frames with game data
```

### Pattern 3: UDP with Reliability Layer

```
Client <-> Server: Connectionless UDP packets
                   with sequence numbers and ACKs
```

### Pattern 4: Hybrid TCP + UDP

```
TCP: Authentication, chat, non-critical updates
UDP: Player movement, fast game state updates
```

## State Synchronization Patterns

### Pattern 1: Full State Updates

Server sends complete game state periodically.

```c
struct GameState {
    uint32_t tick;
    Player players[64];
    Entity entities[1000];
    // Complete world state
};
```

**Pros:** Simple, reliable
**Cons:** High bandwidth

### Pattern 2: Delta Updates

Server sends only changes since last update.

```c
struct DeltaUpdate {
    uint32_t tick;
    uint16_t num_changes;
    Change changes[];
};

struct Change {
    uint16_t entity_id;
    uint8_t field_mask;  // Which fields changed
    uint8_t data[];      // Only changed data
};
```

**Pros:** Efficient bandwidth
**Cons:** More complex

### Pattern 3: Event-Based

Server sends discrete events.

```c
struct Event {
    uint16_t event_type;
    uint32_t timestamp;
    uint8_t event_data[];
};

// Examples:
// PLAYER_MOVED, ITEM_PICKED, DAMAGE_DEALT, etc.
```

## Encryption Patterns

### Pattern 1: No Encryption

Plain TCP/UDP (older games).

```
[Message bytes] → Network → [Message bytes]
```

### Pattern 2: SSL/TLS

Modern standard encryption.

```
Client -> Server: TLS Handshake
Client <-> Server: Encrypted channel
```

### Pattern 3: Custom XOR Obfuscation

Simple obfuscation (not secure).

```c
void xor_encrypt(uint8_t* data, size_t len, uint8_t key) {
    for (size_t i = 0; i < len; i++) {
        data[i] ^= key;
    }
}
```

### Pattern 4: AES Encryption

Proper encryption for game data.

```c
// Session key from authentication
uint8_t session_key[32];

// Encrypt each message
encrypt_aes_256(message, length, session_key, iv);
```

## Common Message Types

### Core Messages

```
0x0001: LOGIN_REQUEST
0x0002: LOGIN_RESPONSE
0x0003: LOGOUT
0x0004: KEEPALIVE / PING
0x0005: PONG
```

### Player Messages

```
0x0010: PLAYER_MOVE
0x0011: PLAYER_ACTION
0x0012: PLAYER_ATTACK
0x0013: PLAYER_USE_ITEM
0x0014: PLAYER_STATE_UPDATE
```

### Chat Messages

```
0x0020: CHAT_MESSAGE
0x0021: CHAT_WHISPER
0x0022: CHAT_PARTY
0x0023: CHAT_GUILD
```

### Game State

```
0x0030: WORLD_UPDATE
0x0031: ENTITY_SPAWN
0x0032: ENTITY_DESPAWN
0x0033: ENTITY_UPDATE
```

## Data Type Patterns

### Coordinates

```c
// Pattern 1: Float coordinates
struct Position {
    float x;
    float y;
    float z;
};

// Pattern 2: Fixed-point (for bandwidth)
struct Position {
    int16_t x;  // Divide by 100 for actual value
    int16_t y;
    int16_t z;
};

// Pattern 3: Grid-based
struct GridPosition {
    uint16_t grid_x;
    uint16_t grid_y;
    uint8_t tile_x;  // Within grid cell
    uint8_t tile_y;
};
```

### Quaternions (Rotation)

```c
struct Rotation {
    float x, y, z, w;  // Quaternion
};

// Or compressed:
struct Rotation {
    int16_t x, y, z;  // w computed from x²+y²+z²+w²=1
};
```

### Inventories

```c
struct Inventory {
    uint16_t num_items;
    Item items[100];
};

struct Item {
    uint32_t item_id;
    uint16_t quantity;
    uint8_t slot;
};
```

## Network Protocol Identifiers

### By Port Numbers

Common game ports:
- 27015: Source Engine (Half-Life, TF2, CS:GO)
- 25565: Minecraft
- 7777: Unreal Engine default
- 3074: Xbox Live
- 3478-3479: PlayStation Network
- 6112: Battle.net (legacy)

### By String Patterns

Look for these strings in binaries:
- "ws://" or "wss://" → WebSocket
- "http://" or "https://" → HTTP-based
- "udp://" → UDP protocol
- "tcp://" → TCP protocol
- ".proto" → Protocol Buffers
- "socket.io" → Socket.IO library

### By Magic Bytes

Some protocols have magic bytes at start:

```
0xFF 0xFF 0xFF 0xFF: Source Engine query
0x00 0x00 0x00 0x01: Some custom protocols
"GPROTO": Custom game protocol marker
```

## Error Handling Patterns

### Pattern 1: Error Codes

```c
struct Response {
    uint8_t success;
    uint16_t error_code;
    char error_message[256];
};

// Error codes:
// 0x0000: Success
// 0x0001: Invalid credentials
// 0x0002: Server full
// 0x0003: Banned
// etc.
```

### Pattern 2: Exception Messages

```json
{
  "success": false,
  "error": {
    "code": "INVALID_SESSION",
    "message": "Session expired"
  }
}
```

## Debugging Tips

### Look for Debug Strings

Many games include debug strings:

```c
printf("Sending login packet: type=%d, len=%d\n", type, len);
```

These help identify protocol details.

### Check for Logging

```c
log_network("Connected to server %s:%d", host, port);
log_network("Received message type 0x%04x", msg_type);
```

### Configuration Files

Check for config files with protocol info:

```ini
[Network]
ServerAddress=game.example.com
Port=7777
Protocol=TCP
UseEncryption=true
```

## Tools and Commands

### Extract Strings

```bash
strings game.exe | grep -i "server\|port\|connect"
```

### Check Networking APIs

```bash
# Linux
ldd game | grep -i "ssl\|socket"

# Windows (with Dependency Walker)
depends.exe game.exe
```

### Capture Network Traffic

```bash
# Capture while game runs
tcpdump -i any -w game_traffic.pcap port 7777

# Or use Wireshark GUI
wireshark &
```

### Analyze Packets

```bash
# With tshark
tshark -r game_traffic.pcap -V

# Or load in Wireshark for detailed analysis
```

## Quick Reference Checklist

When analyzing a game protocol:

- [ ] Identify protocol type (TCP/UDP/WebSocket/HTTP)
- [ ] Find server address and port
- [ ] Determine message structure (header format)
- [ ] List all message types
- [ ] Document authentication flow
- [ ] Check for encryption/obfuscation
- [ ] Map data structures
- [ ] Understand state synchronization
- [ ] Document error handling
- [ ] Test hypotheses with actual traffic

## Common Pitfalls

1. **Endianness:** Always check byte order (little-endian on x86/x64)
2. **Structure Padding:** Compilers add padding; check actual layout
3. **String Encoding:** Could be ASCII, UTF-8, UTF-16, or custom
4. **Compression:** Some protocols compress data (zlib, etc.)
5. **Version Differences:** Protocol may vary between game versions

## Next Steps

Once you've identified the pattern:

1. Document the complete protocol specification
2. Create data structure definitions
3. Write a protocol parser/serializer
4. Implement server handlers
5. Test with actual game client

## Resources

- Wireshark Protocol Wiki: https://wiki.wireshark.org/
- Network Protocol Analysis: Various RFCs and standards
- Game networking articles: Gaffer On Games, etc.

---

This guide is meant as a quick reference. Combine with actual binary analysis using Ghidra for best results.
