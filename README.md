# KGC - King God Castle APK Analysis Toolkit

A professional Unix toolkit for extracting and analyzing the Unity-based mobile game "King God Castle" (킹갓캐슬). Designed for security researchers, reverse engineers, and game developers working on Linux, macOS, and BSD systems.

## 📋 Table of Contents

- [About](#about)
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Analysis Tools](#analysis-tools)
- [Troubleshooting](#troubleshooting)
- [Legal Notice](#legal-notice)

## About

**King God Castle** (`com.awesomepiece.castle`) is a Unity 2022.3+ mobile game by AwesomePiece. This toolkit enables comprehensive analysis of its assets, code structure, and security mechanisms for educational and research purposes.

**Supported Platforms:** Linux, macOS, FreeBSD, OpenBSD, NetBSD

## Features

- **Automated APK Download** - Uses `apkeep` for multi-source downloads
- **XAPK Extraction** - Handles split APK archives seamlessly
- **Unity Asset Analysis** - Deep inspection with AssetRipper integration
- **Security Research** - Anti-cheat detection and obfuscation analysis
- **Cross-Platform** - Native Unix shell scripts for all platforms

## Quick Start

```bash
# 1. Install dependencies
sudo apt install curl wget unzip git  # Ubuntu/Debian
# or
brew install curl wget unzip git      # macOS

# 2. Clone repository
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle

# 3. Install tools
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_linux_x64.zip
unzip AssetRipper_linux_x64.zip -d AssetRipper

# 4. Extract APK
chmod +x main.sh
./main.sh com.awesomepiece.castle

# 5. Analyze with AssetRipper
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
# Method 1: Direct download (Linux)
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_linux_x64.zip
unzip AssetRipper_linux_x64.zip -d AssetRipper
chmod +x AssetRipper/AssetRipper

# Method 2: AUR package (Arch Linux)
yay -S asset-ripper-bin
# or
paru -S asset-ripper-bin

# Method 3: Build from source
git clone https://github.com/AssetRipper/AssetRipper.git
cd AssetRipper
dotnet build -c Release
# Binary will be in: ./Source/AssetRipper/bin/Release/net8.0/

# macOS
curl -L -o AssetRipper_mac.zip https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_mac.zip
unzip AssetRipper_mac.zip -d AssetRipper
```

## Usage

### Basic Extraction

```bash
# Standard extraction
./main.sh com.awesomepiece.castle

# Custom output directory
./main.sh com.awesomepiece.castle ./my_analysis

# Different APK source
./main.sh com.awesomepiece.castle ./output google-play
```

### Script Parameters

| Parameter      | Required | Description        | Default    | Example                   |
| -------------- | -------- | ------------------ | ---------- | ------------------------- |
| `package_name` | Yes      | Android package ID | -          | `com.awesomepiece.castle` |
| `output_dir`   | No       | Extraction path    | `$(pwd)`   | `./analysis`              |
| `source`       | No       | Download source    | `apk-pure` | `google-play`             |

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
   - **YAML** - Human-readable format
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
./main.sh "$PACKAGE" "$OUTPUT_DIR"

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
chmod +x main.sh                    # Fix script permissions
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
nice -n 19 ./main.sh com.awesomepiece.castle
ulimit -v 2097152                   # 2GB memory limit

# High-end systems
export EXTRACTION_THREADS=8
mkdir /tmp/fast_extraction && export TMPDIR=/tmp/fast_extraction
```

### Debug Mode

```bash
export DEBUG=1
bash -x ./main.sh com.awesomepiece.castle 2>&1 | tee debug.log
```

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
