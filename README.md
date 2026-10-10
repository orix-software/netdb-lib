# netdb-lib

[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue.svg)](LICENSE)
[![Version: 2026.4](https://img.shields.io/badge/version-2026.4-brightgreen.svg)](VERSION)

**Network Database Library for Orix**

`netdb-lib` is a network database operations library for the **Orix** operating system, specifically designed for **6502-based computers** like the Telestrat. It provides DNS resolution functionality, allowing programs to resolve hostnames to IP addresses.

## Overview

This library implements standard network database functions in **6502 assembly** for the Orix environment. It enables DNS queries over UDP sockets to resolve domain names into IP addresses, which is essential for network-enabled applications on retro computing platforms.

### Key Features

- **Hostname Resolution**: Resolve domain names (e.g., `www.oric.org`) to IPv4 addresses
- **DNS Protocol Support**: Implements DNS query formatting and response parsing
- **Socket Integration**: Works with the Orix socket API (UDP)
- **Memory Efficient**: Optimized for 6502's limited memory environment
- **Error Handling**: Comprehensive error reporting for network operations

### Implemented Functions

| Function | Description |
|----------|-------------|
| `gethostbyname` | Resolves a hostname to an IP address using DNS |
| `getaddrinfo` | Gets address information for a hostname |
| `netdberror` | Returns human-readable error messages |

## Requirements

- **Orix OS** (Minimum version: 2024.1)
- **6502 CPU** (Telestrat compatible)
- **Socket Library** (from orix-software ecosystem)
- **CH395 Library** (for network interface access)
- **CC65 toolchain** (for compilation)

## Installation

### Prerequisites

Ensure you have the following dependencies installed:

```bash
# Clone the repository with submodules
git clone --recursive https://github.com/orix-software/netdb-lib.git
cd netdb-lib

# Or initialize submodules after cloning
git submodule update --init --recursive
```

### Building

The library can be built using the provided Makefile:

```bash
# Build the library
make

# Clean build artifacts
make clean
```

The build process will:
1. Assemble all source files (`*.s`) from the `src/` directory
2. Generate object files (`*.o`)
3. Create the library archive `netdb.lib`
4. Copy outputs to the `build/` and `target/telestrat/lib/` directories

### Manual Build Setup

If you prefer manual setup:

1. **Download Dependencies**:
   ```bash
   ./configure
   ```
   This script downloads required libraries (socketlib, ch395lib) from the Orix repository.

2. **Set Environment** (optional):
   ```bash
   export CC65_HOME=/path/to/cc65
   ```

3. **Compile**:
   ```bash
   make
   ```

## Usage

### In Assembly

```assembly
.include "netdb.inc"
.import gethostbyname

; Example: Resolve a hostname
    lda #<hostname
    ldy #>hostname
    jsr gethostbyname
    ; Returns IP in A,Y,X,TR1 on success
    ; Returns 0 in A with error code in X on failure
```

### In C

```c
#include <netdb.h>

struct hostent *resolve_hostname(const char *name) {
    return gethostbyname(name);
}
```

## API Reference

### gethostbyname

**Prototype (C):**
```c
struct hostent *gethostbyname(const char *name);
```

**Registers (Assembly):**
- **Input**: A,Y = pointer to null-terminated hostname string
- **Output**: A,Y,X,TR1 = IP address (4 bytes)
- **Error**: A = 0, X = error code

**Structure:**
```c
struct hostent {
    char  *h_name;        // Official name of the host
    char **h_aliases;     // Array of alternative names
    int    h_addrtype;    // Address type (usually AF_INET)
    int    h_length;      // Length of addresses in bytes
    char **h_addr_list;   // Array of host addresses
};
```

### getaddrinfo

**Prototype (C):**
```c
int getaddrinfo(const char *node, const char *service,
                const struct addrinfo *hints,
                struct addrinfo **res);
```

**Structure:**
```c
struct addrinfo {
    int              ai_flags;     // Request options
    int              ai_family;    // Address family (AF_INET, AF_INET6)
    int              ai_socktype;  // Socket type
    int              ai_protocol;  // Protocol
    size_t           ai_addrlen;   // Address structure length
    char            *ai_canonname; // Canonical name
};
```

### Error Codes

The library uses standard socket error codes:
- `INVALID_SOCKET` - Invalid socket descriptor
- `EISCONN` - Socket is already connected
- `ENOTCONN` - Socket is not connected
- `ETIMEDOUT` - Connection timed out

Use `netdberror` to get human-readable error messages.

## Configuration

The build can be customized by setting environment variables:

```bash
# Use custom CC65 installation
CC65_HOME=/path/to/cc65 make
```

## Project Structure

```
netdb-lib/
├── src/                    # Source files
│   ├── gethostbyname.s     # Main DNS resolution function
│   ├── getaddrinfo.s      # Address information function
│   ├── netdberror.s       # Error handling
│   ├── strings.s          # String resources
│   └── include/           # Header files
│       └── netdb.h        # C header with structures
│       └── netdb.inc      # Assembly include file
├── build/                  # Build outputs
├── target/                # Target platform outputs
├── libs/                   # External libraries
├── orix-sdk/              # Orix SDK (submodule)
├── docs/                   # Documentation
├── Makefile               # Build configuration
├── configure              # Dependency setup script
├── VERSION                # Current version
├── bpm.tml                # Package metadata
└── README.md              # This file
```

## DNS Protocol Details

The library constructs standard DNS queries:

```
  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ID                       |QR|   Opcode  |AA|TC|RD|
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|RA|   Z    |   RCODE   |            QDCOUNT            |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|            ANCOUNT            |            NSCOUNT           |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                     |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```

Queries are sent to the DNS server (default: port 53 on IP defined in socket configuration).

## Testing

The library includes test cases in the `test/` directory. Run tests with:

```bash
cd test
make
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Version History

- **2026.4** (Current) - Updated for Orix 2024.4 compatibility
- **2024.4** - Initial stable release
- See [VERSION](VERSION) file for current version

## License

This project is dual-licensed under:
- **MIT License**
- **Apache License 2.0**

See the [LICENSE](LICENSE) file for details.

## Resources

- **Homepage**: [https://orix-software.github.io/netdb-lib](https://orix-software.github.io/netdb-lib)
- **Repository**: [https://github.com/orix-software/netdb-lib](https://github.com/orix-software/netdb-lib)
- **Documentation**: [https://orix-software.github.io/inetlib/](https://orix-software.github.io/inetlib/)
- **Orix Operating System**: [https://github.com/orix-software](https://github.com/orix-software)
- **CC65 Compiler**: [https://cc65.github.io/](https://cc65.github.io/)

## Acknowledgments

- The Orix development team
- CC65 contributors
- Retro computing community
- All contributors to the orix-software ecosystem

---

*Built with passion for retro computing on 6502 processors.*
