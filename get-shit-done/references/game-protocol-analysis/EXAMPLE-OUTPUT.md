# Example Game Protocol Analysis

This is a sample analysis session showing what the output looks like when analyzing a fictional game called "Legacy MMO".

## Project Setup

```
/gsd:analyze-game-protocol ./LegacyMMO.exe

> Game name? "Legacy MMO"
> Platform? "Windows x64"
> Server status? "Shut down in 2015"
> Known info? "TCP-based, used port 7777"
> Analysis goal? "Recreate server for private hosting"
> Ghidra installed? "Yes"
```

## Generated Structure

```
.planning/game-protocol-analysis/
└── legacy-mmo/
    ├── PROJECT.md
    ├── SESSION-001.md
    ├── PROTOCOL.md
    ├── SERVER-GUIDE.md
    ├── SUMMARY.md
    ├── ghidra-projects/
    │   └── LegacyMMO.gpr
    ├── findings/
    │   ├── network-functions.txt
    │   ├── message-types.txt
    │   └── structures.h
    └── protocol-docs/
        ├── authentication.md
        ├── message-format.md
        └── connection-flow.md
```

## Sample PROTOCOL.md Output

```markdown
# Legacy MMO Server Protocol Specification

## Overview
- **Protocol Type:** TCP
- **Default Port:** 7777
- **Encryption:** None (plaintext)
- **Message Format:** Binary with fixed header

## Connection Flow

1. Client connects to server on port 7777
2. Server sends WELCOME message with server version
3. Client sends LOGIN_REQUEST with credentials
4. Server responds with LOGIN_RESPONSE (success/failure)
5. If successful, client and server exchange game messages

## Message Format

### Header Structure

All messages use this header:

```c
struct MessageHeader {
    uint16_t message_type;    // Message type identifier
    uint32_t message_length;  // Payload length in bytes
};
```

Size: 6 bytes
Byte order: Little-endian

### Message Types

#### 0x0001: LOGIN_REQUEST

Sent by client to authenticate.

```c
struct LoginRequest {
    MessageHeader header;
    char username[32];        // Null-terminated
    char password_hash[64];   // SHA256 as hex string
    uint32_t client_version;  // Client version number
};
```

Size: 106 bytes

#### 0x0002: LOGIN_RESPONSE

Server response to login attempt.

```c
struct LoginResponse {
    MessageHeader header;
    uint8_t success;          // 1 = success, 0 = failure
    char session_token[64];   // Session token if success
    uint32_t player_id;       // Player ID if success
    char error_message[128];  // Error if failure
};
```

Size: 203 bytes

#### 0x0010: PLAYER_MOVE

Player position update (sent frequently).

```c
struct PlayerMove {
    MessageHeader header;
    float x;                  // X coordinate
    float y;                  // Y coordinate
    float z;                  // Z coordinate
    uint16_t facing;          // Facing angle (0-359)
};
```

Size: 20 bytes

#### 0x0020: CHAT_MESSAGE

Chat message from client.

```c
struct ChatMessage {
    MessageHeader header;
    uint8_t channel;          // 0=general, 1=party, 2=guild
    char message[256];        // Message text
};
```

Size: 263 bytes

[... more message types ...]

## Authentication Flow

1. Client collects username and password
2. Client computes SHA256 hash of password
3. Client converts hash to hex string (64 characters)
4. Client sends LOGIN_REQUEST with username and hash
5. Server verifies credentials against database
6. Server generates session token (random 64 bytes)
7. Server sends LOGIN_RESPONSE with success=1 and token
8. Client stores session token
9. Session token is NOT included in subsequent messages (connection-based auth)

## Security Considerations

**⚠️ WARNING:** This protocol has several security issues:

- **No encryption:** All data sent in plaintext over TCP
- **Password hashing:** SHA256 without salt is weak
- **No token in messages:** Session security relies only on TCP connection
- **No replay protection:** Messages could be replayed
- **No rate limiting:** Vulnerable to spam/DoS

**Recommendations for modern implementation:**
- Add TLS/SSL encryption
- Use proper password hashing (bcrypt, Argon2)
- Include session token in messages
- Add message sequence numbers
- Implement rate limiting

## Implementation Notes

### Required Server Components

1. **TCP Socket Listener** on port 7777
2. **Authentication System** with user database
3. **Session Manager** to track connected players
4. **Message Router** to dispatch messages by type
5. **Game State Manager** for world/player state
6. **Broadcast System** for multi-client updates

### Recommended Libraries

**Python:**
- `socket` for networking
- `struct` for binary packing
- `hashlib` for SHA256
- `sqlite3` for user database

**Node.js:**
- `net` for TCP server
- `buffer` for binary handling
- `crypto` for hashing
- Database of choice

**Go:**
- `net` package for networking
- `encoding/binary` for structures
- `crypto/sha256` for hashing
- Database of choice

## Testing

### Connecting to Server

```python
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('localhost', 7777))

# Wait for WELCOME message
welcome = sock.recv(1024)
print(f"Welcome: {welcome}")

# Send LOGIN_REQUEST
# ... construct and send message
```

### Packet Capture

If the original game still runs:

```bash
# Capture traffic
tcpdump -i any -w legacy-mmo.pcap port 7777

# Or use Wireshark
wireshark -k -i any -f "port 7777"
```

This allows verification of the protocol spec.
```

## Sample SERVER-GUIDE.md Output

```markdown
# Legacy MMO Server Implementation Guide

## Quick Start

This guide shows you how to implement a compatible server for Legacy MMO.

## Architecture

```
┌─────────┐     TCP/7777      ┌──────────────┐
│ Client  │ ◄──────────────► │    Server    │
└─────────┘                   └──────┬───────┘
                                     │
                    ┌────────────────┼────────────────┐
                    ▼                ▼                ▼
            ┌───────────┐    ┌──────────┐    ┌──────────┐
            │   Auth    │    │ Session  │    │  Game    │
            │  Manager  │    │ Manager  │    │  State   │
            └───────────┘    └──────────┘    └──────────┘
```

## Step 1: Basic TCP Server

### Python Example

```python
import socket
import struct
import threading

class LegacyMMOServer:
    def __init__(self, port=7777):
        self.port = port
        self.clients = {}
        
    def start(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('0.0.0.0', self.port))
        server.listen(5)
        
        print(f"Legacy MMO Server listening on port {self.port}")
        
        while True:
            client, addr = server.accept()
            print(f"Client connected: {addr}")
            thread = threading.Thread(target=self.handle_client, args=(client,))
            thread.start()
    
    def handle_client(self, client):
        # Send welcome message
        self.send_welcome(client)
        
        # Handle messages
        while True:
            try:
                # Read header (6 bytes)
                header = client.recv(6)
                if not header:
                    break
                
                msg_type, msg_length = struct.unpack('<HI', header)
                
                # Read payload
                payload = client.recv(msg_length)
                
                # Route message
                self.handle_message(client, msg_type, payload)
                
            except Exception as e:
                print(f"Client error: {e}")
                break
        
        client.close()
    
    def send_welcome(self, client):
        # Send WELCOME message (type 0x0000)
        msg_type = 0x0000
        payload = b"Welcome to Legacy MMO Server v1.0"
        header = struct.pack('<HI', msg_type, len(payload))
        client.send(header + payload)
    
    def handle_message(self, client, msg_type, payload):
        if msg_type == 0x0001:  # LOGIN_REQUEST
            self.handle_login(client, payload)
        elif msg_type == 0x0010:  # PLAYER_MOVE
            self.handle_player_move(client, payload)
        elif msg_type == 0x0020:  # CHAT_MESSAGE
            self.handle_chat(client, payload)
        else:
            print(f"Unknown message type: 0x{msg_type:04x}")
    
    def handle_login(self, client, payload):
        # Parse login request
        username = payload[0:32].decode('utf-8').rstrip('\x00')
        password_hash = payload[32:96].decode('utf-8')
        client_version = struct.unpack('<I', payload[96:100])[0]
        
        print(f"Login attempt: {username}")
        
        # TODO: Verify credentials against database
        # For now, accept all logins
        
        success = True
        session_token = "test-session-token".ljust(64, '\x00')
        player_id = 12345
        error_message = "".ljust(128, '\x00')
        
        # Send LOGIN_RESPONSE
        response = struct.pack('<HI', 0x0002, 197)  # type + length
        response += struct.pack('<B', 1 if success else 0)  # success
        response += session_token.encode('utf-8')
        response += struct.pack('<I', player_id)
        response += error_message.encode('utf-8')
        
        client.send(response)
        
        if success:
            self.clients[client] = {
                'username': username,
                'player_id': player_id,
                'session_token': session_token
            }
    
    def handle_player_move(self, client, payload):
        x, y, z, facing = struct.unpack('<fffH', payload)
        print(f"Player move: ({x}, {y}, {z}) facing {facing}")
        
        # TODO: Update game state and broadcast to other players
    
    def handle_chat(self, client, payload):
        channel = struct.unpack('<B', payload[0:1])[0]
        message = payload[1:257].decode('utf-8').rstrip('\x00')
        print(f"Chat [channel {channel}]: {message}")
        
        # TODO: Broadcast to appropriate channel

if __name__ == '__main__':
    server = LegacyMMOServer()
    server.start()
```

## Step 2: Add Database

```python
import sqlite3

class UserDatabase:
    def __init__(self, db_path='users.db'):
        self.conn = sqlite3.connect(db_path, check_same_thread=False)
        self.create_tables()
    
    def create_tables(self):
        self.conn.execute('''
            CREATE TABLE IF NOT EXISTS users (
                player_id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password_hash TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        self.conn.commit()
    
    def verify_user(self, username, password_hash):
        cursor = self.conn.execute(
            'SELECT player_id FROM users WHERE username=? AND password_hash=?',
            (username, password_hash)
        )
        row = cursor.fetchone()
        return row[0] if row else None
    
    def create_user(self, username, password_hash):
        try:
            cursor = self.conn.execute(
                'INSERT INTO users (username, password_hash) VALUES (?, ?)',
                (username, password_hash)
            )
            self.conn.commit()
            return cursor.lastrowid
        except sqlite3.IntegrityError:
            return None  # User already exists
```

## Step 3: Session Management

```python
import secrets
import time

class SessionManager:
    def __init__(self):
        self.sessions = {}
    
    def create_session(self, player_id, username):
        token = secrets.token_hex(32)  # 64 character hex string
        self.sessions[token] = {
            'player_id': player_id,
            'username': username,
            'created_at': time.time()
        }
        return token
    
    def validate_session(self, token):
        return token in self.sessions
    
    def get_session(self, token):
        return self.sessions.get(token)
    
    def remove_session(self, token):
        if token in self.sessions:
            del self.sessions[token]
    
    def cleanup_old_sessions(self, max_age=3600):
        current_time = time.time()
        expired = [
            token for token, session in self.sessions.items()
            if current_time - session['created_at'] > max_age
        ]
        for token in expired:
            del self.sessions[token]
```

## Next Steps

1. **Test with Client:** Run the original game and connect to your server
2. **Add Game Logic:** Implement game-specific features
3. **Add More Handlers:** Implement handlers for all message types
4. **Improve Security:** Add TLS, better auth, rate limiting
5. **Scale:** Add database pooling, async I/O, load balancing

## Troubleshooting

### Client Won't Connect

- Check firewall allows port 7777
- Verify server is listening: `netstat -an | grep 7777`
- Test with telnet: `telnet localhost 7777`

### Protocol Mismatches

- Verify byte order (little-endian)
- Check structure sizes match
- Use Wireshark to compare packets

## Resources

- Original PROTOCOL.md specification
- Python `socket` documentation
- Python `struct` format strings
- SQLite Python tutorial
```

## Analysis Output Summary

The analysis produces:

1. **Complete Protocol Specification** - Every message type, structure, and flow documented
2. **Implementation Guide** - Working code examples in multiple languages
3. **Security Analysis** - Known vulnerabilities and recommendations
4. **Testing Instructions** - How to verify the implementation
5. **Troubleshooting** - Common issues and solutions

This documentation is sufficient to implement a fully compatible server without access to the original server code.
