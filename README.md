# King God Castle APK Analysis Toolkit

A comprehensive toolkit for extracting and analyzing the Unity-based mobile game "King God Castle" (킹갓캐슬). Designed for security researchers, reverse engineers, and game developers working on Unix-based systems.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start Guide](#quick-start-guide)
- [Installation](#installation)
- [Usage Instructions](#usage-instructions)
- [Analysis Tools](#analysis-tools)
- [Troubleshooting](#troubleshooting)
- [Legal Notice](#legal-notice)

## Overview

**King God Castle** (`com.awesomepiece.castle`) is a Unity 2022.3+ mobile game developed by AwesomePiece. This toolkit facilitates in-depth analysis of its assets, code structure, and security mechanisms for educational and research purposes.

**Supported Platforms:** Linux, macOS, FreeBSD, OpenBSD, NetBSD

## Features

- **Automated APK Download**: Utilizes `apkeep` for APK-Pure downloads.
- **XAPK Extraction**: Seamlessly handles split APK archives.
- **Unity Asset Analysis**: Integrates with AssetRipper for deep inspection.
- **Security Research**: Includes tools for anti-cheat detection and obfuscation analysis.
- **Cross-Platform Compatibility**: Native Unix shell scripts for all supported platforms.

## Quick Start Guide

```bash
# Step 1: Install dependencies
sudo apt install curl wget unzip git  # For Ubuntu/Debian
brew install curl wget unzip git      # For macOS

# Step 2: Clone the repository
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle

# Step 3: Install required tools
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_linux_x64.zip
unzip AssetRipper_linux_x64.zip -d AssetRipper

# Step 4: Extract APK
chmod +x install.sh
./install.sh

# Step 5: Analyze assets with AssetRipper
./AssetRipper/AssetRipper
# File → Load folder → Select: ./com.awesomepiece.castle_extracted/base_assets/
# Export → Export all files → Choose destination
```

## Installation

### Linux Distributions

#### Ubuntu/Debian

```bash
sudo apt update && sudo apt install -y curl wget unzip git build-essential python3 dotnet-runtime-8.0
```

#### Fedora/RHEL/CentOS

```bash
sudo dnf update -y && sudo dnf install -y curl wget unzip git gcc make python3 dotnet-runtime-8.0
```

#### Arch Linux

```bash
sudo pacman -Syu && sudo pacman -S curl wget unzip git base-devel python dotnet-runtime
yay -S apkeep-bin  # Optional: AUR package
```

### macOS

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install curl wget unzip git python3 dotnet
sudo softwareupdate --install-rosetta --agree-to-license  # Apple Silicon only
```

### Tool Installation

#### APKeep (APK Downloader)

```bash
# Automated installation
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Manual installation
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-linux-amd64
    chmod +x apkeep-linux-amd64 && sudo mv apkeep-linux-amd64 /usr/local/bin/apkeep
fi
```

#### AssetRipper (Unity Asset Extractor)

```bash
# Direct download (Linux)
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_linux_x64.zip
unzip AssetRipper_linux_x64.zip -d AssetRipper
chmod +x AssetRipper/AssetRipper

# AUR package (Arch Linux)
yay -S asset-ripper-bin
# or
paru -S asset-ripper-bin

# Build from source
git clone https://github.com/AssetRipper/AssetRipper.git
cd AssetRipper
dotnet build -c Release
# Binary will be in: ./Source/AssetRipper/bin/Release/net8.0/

# macOS
curl -L -o AssetRipper_mac.zip https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_mac.zip
unzip AssetRipper_mac.zip -d AssetRipper
```

## Usage Instructions

**Note:** The script automatically downloads from APK-Pure. The package `com.awesomepiece.castle` is hardcoded for King God Castle.

### Basic Extraction

```bash
# Standard extraction to current directory
./install.sh

# Custom output directory
./install.sh ./my_analysis

# Verbose output
./install.sh -v ./analysis

# Quiet mode (only errors)
./install.sh -q ./output
```

### Script Parameters

| Parameter    | Required | Description     | Default  | Example      |
| ------------ | -------- | --------------- | -------- | ------------ |
| `output_dir` | No       | Extraction path | `$(pwd)` | `./analysis` |

### Script Options

| Option          | Description                                         |
| --------------- | --------------------------------------------------- |
| `-h, --help`    | Show help message and usage information             |
| `-v, --verbose` | Enable verbose output with directory structure info |
| `-q, --quiet`   | Suppress all output except errors                   |

### Environment Variables

```bash
export TMPDIR=/var/tmp              # Custom temp directory
export EXTRACTION_THREADS=4         # Parallel processing
export DEBUG=1                      # Debug mode
```

### AssetRipper Workflow

1. **Launch AssetRipper**: `./AssetRipper/AssetRipper`
2. **Load Assets**: File → Load folder → `./com.awesomepiece.castle_extracted/base_assets/`
3. **Export Project**: Export → Export all files → Choose format:
   - **Unity Project** - Complete Unity project
   - **Native** - Original asset format

## Analysis Tools

### Command-Line Asset Analysis

```bash
# Extract with AssetRipper CLI
./AssetRipper/AssetRipper ./extracted/base_assets/ -o ./unity_project/ --export-format=yaml

# Find Unity scenes
find ./extracted/ -name "*.unity" -exec echo "Scene: {}" \;

# Analyze libraries
strings ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so | grep -E "(encrypt|decrypt|key)"

# Network endpoints
grep -r -E "https?://[^\"']*" ./extracted/ | grep -v Binary | sort -u
```

### Security Analysis

```bash
# Anti-debug detection
grep -r "ptrace\|debugger\|gdb" ./extracted/

# Root detection
grep -r -i "root\|superuser\|magisk\|xposed" ./extracted/

# Obfuscation analysis
objdump -T ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so | grep -i unity
```

### Automated Pipeline

```bash
#!/bin/bash
# analysis_pipeline.sh
PACKAGE="com.awesomepiece.castle"
OUTPUT_DIR="./analysis_$(date +%Y%m%d_%H%M%S)"

# Extract APK
./install.sh "$OUTPUT_DIR"

# Analyze with AssetRipper
./AssetRipper/AssetRipper "$OUTPUT_DIR/${PACKAGE}_extracted/base_assets/" -o "$OUTPUT_DIR/unity_assets/"

# Generate security report
grep -r -i "password\|secret\|key\|token" "$OUTPUT_DIR/${PACKAGE}_extracted/" > "$OUTPUT_DIR/security_report.txt"

echo "Analysis complete! Results in $OUTPUT_DIR"
```

### Game Technical Details

- **Package**: `com.awesomepiece.castle`
- **Engine**: Unity 2022.3+ with IL2CPP
- **Size**: ~758MB (XAPK format)
- **Architecture**: ARMv7a/ARM64
- **Languages**: 40+ supported
- **Technologies**: Firebase, Unity Ads, ACTk Anti-Cheat

## Troubleshooting

### Permission Issues

```bash
chmod +x install.sh                    # Fix script permissions
chmod 755 ./extracted/              # Fix directory permissions
```

### Missing Dependencies

```bash
# APKeep missing
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Unzip missing
sudo apt install unzip              # Ubuntu/Debian
sudo dnf install unzip              # Fedora/RHEL
sudo pacman -S unzip                # Arch Linux
```

### Storage Issues

```bash
df -h .                             # Check available space
rm -rf /tmp/apkeep_*                # Clean temporary files
export TMPDIR=/var/tmp              # Use different temp directory
```

### Performance Optimization

```bash
# Low-end systems
nice -n 19 ./install.sh ./output
ulimit -v 2097152                   # 2GB memory limit

# High-end systems
export EXTRACTION_THREADS=8
mkdir /tmp/fast_extraction && export TMPDIR=/tmp/fast_extraction
```

### Debug Mode

```bash
export DEBUG=1
bash -x ./install.sh ./output 2>&1 | tee debug.log
```

## Development

### Release Process

This project uses automated releases via GitHub Actions. See [Release Process Documentation](docs/RELEASE_PROCESS.md) for detailed information.

#### Quick Release Creation

```bash
# Using the helper script
./scripts/create-release.sh 1.2.3

# Manual method
git checkout -b v1.2.3
git push -u origin v1.2.3
```

#### Version Naming

Follow [Semantic Versioning](https://semver.org/):

- `v1.2.3` - Stable release
- `v2.0.0-beta.1` - Pre-release
- `v1.1.1-rc.2` - Release candidate

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

For releases, create a version branch (`v*`) to trigger automated release creation.

## Legal Notice

**Educational Use Only** - This tool is designed for legitimate research and educational purposes:

✅ **Allowed:**

- Personal learning and security research
- Academic study and analysis
- Responsible security vulnerability disclosure

❌ **Forbidden:**

- Commercial exploitation without proper licensing
- Redistribution of copyrighted assets
- Circumventing copy protection for piracy

**Disclaimer:** Users are solely responsible for ensuring compliance with applicable laws and regulations. The authors assume no liability for misuse of this software.

---

**License:** MIT | **Support:** [GitHub Issues](https://github.com/nowl-it/King-God-Castle/issues) | **Documentation:** [AssetRipper](https://github.com/AssetRipper/AssetRipper) • [APKeep](https://github.com/EFForg/apkeep)

Anh em mình cứ vậy thôi hẹ hẹ
